resource "google_project_service" "gke" {
  project            = "${var.gcp_project}"
  disable_on_destroy = false

  service = "container.googleapis.com"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# ------------------------------------------------------------------------------
# Create a Kubernetes cluster
# ------------------------------------------------------------------------------

resource "google_container_cluster" "gke_cluster" {
  depends_on = ["google_project_service.gke"]

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
