terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"
}

# ------------------------------------------------------------------------------
# GKE KUBERNETES CLUSTER AND NODE POOL
# ------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  lifecycle {
    create_before_destroy = true
  }

  name = "${var.cluster["name"]}"
  zone = "${var.cluster["main_zone"]}"

  additional_zones = "${var.cluster["additional_zones"]}"

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
# Create an auto-scaling node pool for the cluster [disabled]
# ------------------------------------------------------------------------------

resource "google_container_node_pool" "nodepool" {
  count = 0

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

  lifecycle {
    create_before_destroy = true
  }
}
