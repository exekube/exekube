# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "Project where resources will be created"
}

variable "serviceaccount_key" {
  description = "Service account key for the project"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "network_name" {
  default = "network"
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
