# TBD

// cluster vars

variable "cluster_name" {
  description = ""
  default = "k8s-cluster"
}

variable "gcp_zone" {
  description = ""
  default = "europe-west1-d"
}

variable "node_version" {
  description = ""
  default = "1.8.4-gke.0"
}

variable "node_type" {
  description = ""
  default = "n1-standard-2"
}

variable "master_version" {
  description = ""
  default = "1.8.4-gke.0"
}

variable "enable_legacy_auth" {
  description = ""
  default = "false"
}

// node pool vars

variable "nodepool_name" {
  description = ""
  default = "k8s-nodepool"
}

variable "nodepool_max_nodes" {
  description = ""
  default = 4
}

variable "nodepool_machine_type" {
  description = ""
  default = "n1-standard-2"
}
