# ------------------------------------------------------------------------------
# GCP PROJECT
# ------------------------------------------------------------------------------

# Create a unique ID suffix for project name
resource "random_id" "id" {
  byte_length = 4
  prefix      = "${basename(var.gcp_product_env_path)}-${var.gcp_product_name}-"
}

# Create a GCP project for this product environment
# TODO: make possible to use folder_id ("product folder") instead of org_id
# Use of folder_id requires to have organization admin permissions
# Remember roles/resourcemanager.projectCreator role for Terraform admin SA
resource "google_project" "project" {
  name            = "${random_id.id.hex}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.gcp_billing_id}"
  org_id          = "${var.gcp_org_id}"
  skip_delete     = false
}

# List all APIs we are going to need for this project
# TODO: Review and remove APIs that we will not use
resource "google_project_services" "project" {
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
    command = "sleep 15"
  }
}

# ------------------------------------------------------------------------------
# IAM POLICY (AUDIT CONFIG)
# Support for AuditConfigs is missing in terraform-provider-google
# GitHub issue:
# https://github.com/terraform-providers/terraform-provider-google/issues/936
# That's why we use the bash script "audit-config.sh" for now
# ------------------------------------------------------------------------------

resource "null_resource" "audit_config" {
  depends_on = ["google_project_services.project"]

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
# SECRET MANAGEMENT / KMS (KEYRINGS AND CRYPTOKEYS)
# ------------------------------------------------------------------------------

resource "google_kms_key_ring" "key_ring" {
  project  = "${google_project.project.project_id}"
  name     = "${basename(var.gcp_product_env_path)}"
  location = "global"
}

resource "google_kms_crypto_key" "crypto_key" {
  count = "${length(var.crypto_keys)}"

  name     = "${element(var.crypto_keys, count.index)}" # team1 team2
  key_ring = "${google_kms_key_ring.key_ring.id}"
}

resource "google_storage_bucket" "secrets_store" {
  count = "${length(var.crypto_keys)}"

  project       = "${google_project.project.project_id}"
  name          = "${google_project.project.project_id}-${element(var.crypto_keys, count.index)}-secrets"
  force_destroy = true
  location      = "${var.gcp_region}"
  storage_class = "REGIONAL"
}

# ---
# TODO: Use variables for setting permissions for
# Bucket -- objectViewer, objectCreator, objectAdmin
# KeyRing -- Admin, User
# CryptoKey -- Admin, User
# ---

# ------------------------------------------------------------------------------
# GKE KUBERNETES CLUSTER AND NODE POOL
# ------------------------------------------------------------------------------

# TODO: Configure network and firewall rules
# TODO: Add custom role for fetching credentials
# TODO: Configure access for user accounts
# TODO: Secure ingress / egress networking
# TODO: Add (automated?) tests for access / networking security
# TODO: Figure out access to Helm/Tiller and how to restrict it

resource "google_container_cluster" "gke_cluster" {
  depends_on = ["google_project_service.gke"]

  project            = "${google_project.project.project_id}"
  name               = "${var.cluster_name}"
  zone               = "${var.gcp_zone}"
  initial_node_count = 2

  cluster_ipv4_cidr  = "10.20.0.0/14"
  node_version       = "${var.gke_version}"
  min_master_version = "${var.gke_version}"
  enable_legacy_abac = "${var.enable_legacy_auth}"
  subnetwork         = "default"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "${var.node_type}"
  }

  provisioner "local-exec" {
    # configure "kubectl" credentials
    command = <<EOF
sleep 5 \
&& gcloud auth activate-service-account --key-file $GOOGLE_CREDENTIALS \
&& gcloud container clusters get-credentials ${var.cluster_name} \
--zone ${var.gcp_zone} \
--project ${var.gcp_project} \
&& kubectl -n kube-system create sa tiller \
&& kubectl create clusterrolebinding tiller \
--clusterrole cluster-admin \
--serviceaccount=kube-system:tiller \
&& helm init --service-account tiller \
&& sleep 15 \
&& helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
EOF
  }

  lifecycle {
    create_before_destroy = true
  }
}

# TODO: Add variable for enabling / disabling additional node pools
resource "google_container_node_pool" "nodepool" {
  count = 0

  project    = "${google_project.project.project_id}"
  name       = "${var.nodepool_name}"
  zone       = "${var.gcp_zone}"
  cluster    = "${google_container_cluster.gke_cluster.name}"
  node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = "${var.nodepool_max_nodes}"
  }

  node_config {
    machine_type = "${var.nodepool_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  lifecycle {
    create_before_destroy = true
  }
}
