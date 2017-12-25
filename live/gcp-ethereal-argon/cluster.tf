module "gke_cluster" {
  source = "../../modules/gke-cluster"
  cluster_name = "my-k8s-cluster"
  nodepool_name = "my-k8s-np"
  gke_version = "1.8.4-gke.1"
  gcp_project = "ethereal-argon-186217"
}
