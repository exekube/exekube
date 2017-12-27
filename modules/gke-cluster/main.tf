resource "google_container_cluster" "gke_cluster" {
  name               = "${var.cluster_name}"
  zone               = "${var.gcp_zone}"
  initial_node_count = 1

  cluster_ipv4_cidr  = "10.20.0.0/14"
  node_version       = "${var.gke_version}"
  min_master_version = "${var.gke_version}"
  enable_legacy_abac = "${var.enable_legacy_auth}"
  subnetwork         = "default"

  node_config {
    machine_type = "${var.node_type}"
  }

  provisioner "local-exec" {
    # configure "kubectl" credentials
    command = <<EOF
gcloud container clusters get-credentials ${var.cluster_name} \
--zone ${var.gcp_zone} \
--project ${var.gcp_project} \
&& kubectl -n kube-system create sa tiller \
&& kubectl create clusterrolebinding tiller \
--clusterrole cluster-admin \
--serviceaccount=kube-system:tiller \
&& helm init --service-account tiller \
&& helm init --upgrade --service-account tiller \
&& sleep 15
EOF
  }
}

resource "google_container_node_pool" "nodepool" {
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
  }
}
