# TBD

// cluster vars

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "gcp_zone" {
  default = "europe-west1-d"
}

variable "node_version" {
  default = "1.8.4-gke.0"
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "master_version" {
  default = "1.8.4-gke.0"
}

variable "enable_legacy_auth" {
  default = "false"
}

// node pool vars

variable "nodepool_name" {
  default = "k8s-nodepool"
}

variable "nodepool_max_nodes" {
  default = 4
}

variable "nodepool_machine_type" {
  default = "n1-standard-2"
}
