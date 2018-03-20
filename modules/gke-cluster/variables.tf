variable "terraform_credentials" {}
variable "project_id" {}
variable "network_name" {}

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "main_compute_zone" {
  default = "europe-west1-d"
}

variable "additional_zones" {
  default = []
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "initial_node_count" {
  default = 2
}

variable "kubernetes_version" {
  default = "1.8.9-gke.1"
}
