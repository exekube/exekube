provider "google" {
  credentials = "${file("credentials.json")}"
  project = "ethereal-argon-186217"
  region  = "europe-west1-d"
}

module "gke_cluster" {
  source = "../../modules/gke-cluster"
  cluster_name = "my-k8s-cluster"
  nodepool_name = "my-k8s-np"
}
