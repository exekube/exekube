# ------------------------------------------------------------------------------
# TERRAFORM REMOTE STATE BACKEND
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

# ------------------------------------------------------------------------------
# TERRAFORM PROVIDERS
# ------------------------------------------------------------------------------

provider "google" {
  credentials = "${var.terraform_credentials}"
}

# ------------------------------------------------------------------------------
# GKE KUBERNETES CLUSTER AND NODE POOL
# ------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  project = "${var.project_id}"

  name = "${var.cluster_name}"
  zone = "${var.main_compute_zone}"

  additional_zones = "${var.additional_zones}"

  initial_node_count = "${var.initial_node_count}"
  node_version       = "${var.kubernetes_version}"
  min_master_version = "${var.kubernetes_version}"
  enable_legacy_abac = "false"
  network            = "${var.network_name}"
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
      disabled = false
    }
  }

  node_config {
    machine_type = "${var.node_type}"
    disk_size_gb = 200

    labels {
      project = "${var.project_id}"
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

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = <<EOF
sleep 5 \
&& gcloud auth activate-service-account --key-file ${var.terraform_credentials} \
&& gcloud container clusters get-credentials ${var.cluster_name} \
--zone "${var.main_compute_zone}" \
--project "${var.project_id}" \
\
\
&& kubectl apply -f ${path.module}/tiller.yaml \
&& helm init \
--service-account tiller \
--override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}' \
&& sleep 20 \
&& helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
EOF
  }
}
