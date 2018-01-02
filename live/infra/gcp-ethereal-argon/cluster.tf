module "gke_cluster" {
  source             = "../../../modules/infra/gke-cluster"
  cluster_name       = "k8s-cluster"
  nodepool_name      = "k8s-np"
  gke_version        = "1.8.4-gke.1"
  enable_legacy_auth = "true"
  gcp_project        = "${var.gcp_project}"
}
