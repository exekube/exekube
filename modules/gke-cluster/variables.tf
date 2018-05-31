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

variable "enable_kubernetes_alpha" {
  default = "false"
}

variable "oauth_scopes" {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "node_image_type" {
  default = "cos"
}

variable "initial_node_count" {
  default = 2
}

variable "kubernetes_version" {
  default = "1.9.7-gke.1"
}
