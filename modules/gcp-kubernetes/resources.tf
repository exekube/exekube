# TODO: Add custom role for fetching credentials
# TODO: Add (automated?) tests for access / networking security
# TODO: Figure out access to Helm/Tiller and how to restrict it
# TODO: Make possible to use folder_id ("product folder") instead of org_id

# ------------------------------------------------------------------------------
# GOOGLE CLOUD PROJECT
# ------------------------------------------------------------------------------

# Create a unique ID suffix for project name
resource "random_id" "id" {
  prefix      = "${basename(var.gcp_product_env_path)}-${var.gcp_product_name}-"
  byte_length = 4
}

resource "google_project" "project" {
  name            = "${random_id.id.hex}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.gcp_billing_id}"
  org_id          = "${var.gcp_org_id}"
  skip_delete     = true
}

# List all APIs we are going to need for this project
# TODO: Review and remove APIs that we will not use
resource "google_project_services" "apis" {
  project = "${google_project.project.project_id}"

  services = [
    "servicemanagement.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "replicapool.googleapis.com",
    "resourceviews.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "cloudkms.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "dns.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
  ]

  # TODO: figure out how much time it takes to enable the APIs
  provisioner "local-exec" {
    command = "sleep 20"
  }
}

# ------------------------------------------------------------------------------
# ENABLE AUDITING FOR STORAGE AND KMS
# Support for AuditConfigs is missing in terraform-provider-google
# GitHub issue:
# https://github.com/terraform-providers/terraform-provider-google/issues/936
# That's why we use the bash script "audit-config.sh" for now
# ------------------------------------------------------------------------------

resource "null_resource" "audit_config" {
  depends_on = ["google_project_services.apis"]

  provisioner "local-exec" {
    command     = "${data.template_file.audit_config.rendered}"
    interpreter = ["/bin/bash"]
  }
}

data "template_file" "audit_config" {
  template = "${file("${path.module}/audit-config.sh")}"

  vars {
    project_id = "${google_project.project.project_id}"
  }
}

# ------------------------------------------------------------------------------
# VPC NETWORK, SUBNETS, FIREWALL RULES
# ------------------------------------------------------------------------------

resource "google_compute_network" "network" {
  project                 = "${google_project.project.project_id}"
  name                    = "${basename(var.gcp_product_env_path)}-${var.gcp_product_name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  depends_on = ["google_project_services.apis"]
  count      = "${length(var.cluster_subnets)}"

  project = "${google_project.project.project_id}"

  network                  = "${google_compute_network.network.self_link}"
  name                     = "nodes"
  ip_cidr_range            = "${element(split(",", lookup(var.cluster_subnets, count.index)), 1)}"
  private_ip_google_access = true
  region                   = "${element(split(",", lookup(var.cluster_subnets, count.index)), 0)}"

  secondary_ip_range = [
    {
      range_name    = "pods"
      ip_cidr_range = "${element(split(",", lookup(var.cluster_subnets, count.index)), 2)}"
    },
    {
      range_name    = "services"
      ip_cidr_range = "${element(split(",", lookup(var.cluster_subnets, count.index)), 3)}"
    },
  ]
}

resource "google_compute_firewall" "allow_nodes_internal" {
  name        = "allow-nodes-internal"
  description = "Allow traffic between nodes in all regions"

  network  = "${google_compute_network.network.name}"
  priority = "65534"

  direction     = "INGRESS"
  source_ranges = ["${google_compute_subnetwork.subnets.*.ip_cidr_range}"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "allow_pods_internal" {
  name     = "allow-pods-internal"
  network  = "${google_compute_network.network.name}"
  priority = "1000"

  description = "Allow traffic between pods and services in all regions"

  # services and pods ranges
  direction = "INGRESS"

  source_ranges = [
    "${google_compute_subnetwork.subnets.*.secondary_ip_range.0.ip_cidr_range}",
    "${google_compute_subnetwork.subnets.*.secondary_ip_range.1.ip_cidr_range}",
  ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

# ------------------------------------------------------------------------------
# GKE KUBERNETES CLUSTER AND NODE POOL
# ------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  depends_on = ["google_project_services.apis"]

  lifecycle {
    create_before_destroy = true
  }

  project = "${google_project.project.project_id}"
  name    = "${var.cluster["name"]}"
  zone    = "${var.gcp_zone}"

  # additional_zones = []

  initial_node_count = "${var.cluster["initial_node_count"]}"
  node_version       = "${var.cluster["kubernetes_version"]}"
  min_master_version = "${var.cluster["kubernetes_version"]}"
  enable_legacy_abac = "false"
  network            = "${google_compute_network.network.name}"
  subnetwork         = "nodes"
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }

    http_load_balancing {
      disabled = true
    }
  }
  node_config {
    machine_type = "${var.cluster["node_type"]}"
    disk_size_gb = 200

    labels {
      project = "${google_project.project.project_id}"
      pool    = "default"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  provisioner "local-exec" {
    command = <<EOF
sleep 5 \
&& gcloud auth activate-service-account --key-file ${var.terraform_credentials} \
&& gcloud container clusters get-credentials ${var.cluster["name"]} \
--zone ${var.gcp_zone} \
--project "${google_project.project.project_id}" \
\
\
&& kubectl -n kube-system create sa tiller \
&& kubectl create clusterrolebinding tiller \
--clusterrole cluster-admin \
--serviceaccount=kube-system:tiller \
&& helm init --service-account tiller \
&& sleep 15 \
&& helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
EOF
  }
}

# ------------------------------------------------------------------------------
# SECRET MANAGEMENT / KMS (KEYRINGS AND CRYPTOKEYS)
# ------------------------------------------------------------------------------

resource "google_kms_key_ring" "key_ring" {
  project  = "${google_project.project.project_id}"
  name     = "${basename(var.gcp_product_env_path)}"
  location = "global"
}

resource "google_kms_crypto_key" "crypto_key" {
  count = "${length(var.crypto_keys)}"

  name     = "${element(var.crypto_keys, count.index)}"
  key_ring = "${google_kms_key_ring.key_ring.id}"
}

resource "google_storage_bucket" "secret_store" {
  count = "${length(var.crypto_keys)}"

  project       = "${google_project.project.project_id}"
  name          = "${google_project.project.project_id}-${element(var.crypto_keys, count.index)}-secrets"
  force_destroy = true
  storage_class = "REGIONAL"
  location      = "${var.gcp_region}"
}

# ---
# TODO: CryptoKey users will have to be set up separately?
# Maybe through additional .tf files in the project live directory
# ---

resource "google_kms_key_ring_iam_binding" "admins" {
  count = "${length(var.key_ring_admins) > 0 ? 1 : 0}"

  key_ring_id = "${google_kms_key_ring.key_ring.id}"
  role        = "roles/cloudkms.admin"

  members = "${var.key_ring_admins}"
}

resource "google_kms_key_ring_iam_binding" "users" {
  count = "${length(var.key_ring_users) > 0 ? 1 : 0}"

  key_ring_id = "${google_kms_key_ring.key_ring.id}"
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = "${var.key_ring_users}"
}
