# ------------------------------------------------------------------------------
# TERRAFORM ADMIN PROJECT
# ------------------------------------------------------------------------------

variable "terraform_project" {
  description = "Project we use for managing Terraform and keep its remote state"
}

variable "terraform_credentials" {
  description = "JSON key for the Terraform service account"
}

# ------------------------------------------------------------------------------
# PRODUCT ENVIRONMENT PROJECT
# ------------------------------------------------------------------------------

variable "gcp_region" {
  default = "europe-west1"
}

variable "gcp_zone" {
  default = "europe-west1-d"
}

variable "gcp_org_id" {
  description = "GCP organization under which new projects will be created"
}

variable "gcp_billing_id" {
  description = "GCP billing ID that will be used for billing the projects"
}

variable "gcp_product_name" {
  description = "Base name used for creating new projects, e.g. 'internal-ops'"
}

variable "gcp_product_env_path" {
  description = "The path to directory for the product environment"
}

# ------------------------------------------------------------------------------
# SECRETS MANAGEMENT AND KMS
# ------------------------------------------------------------------------------

variable "key_ring_admins" {
  description = "Users who have full controll over the keyring"
}

variable "key_ring_users" {
  description = "Users who can encrypt and decrypt keys in the keyring"
}

variable "crypto_keys" {
  type = "list"
}

# ------------------------------------------------------------------------------
# NETWORKING
# ------------------------------------------------------------------------------

variable "subnets" {
  description = "A map of index to a comma separated list of `region,nodes-subnet,pods-subnet,services-subnet` string."

  default = {
    # index = "region,nodes-subnet,pods-subnet,services-subnet"
    "0" = "europe-west1,10.16.0.0/20,10.17.0.0/16,10.18.0.0/16"
  }
}

# ------------------------------------------------------------------------------
# Cluster vars
# ------------------------------------------------------------------------------

variable "cluster_name" {
  default = "k8s-cluster"
}

variable "node_type" {
  default = "n1-standard-2"
}

variable "initial_node_count" {
  description = "Number of initial nodes in each zone"
  default     = 2
}

variable "gke_version" {
  default = "1.8.7-gke.1"
}

# ------------------------------------------------------------------------------
# Node pool vars
# ------------------------------------------------------------------------------

variable "nodepool_name" {
  default = "k8s-nodepool"
}

variable "nodepool_max_nodes" {
  default = 4
}

variable "nodepool_machine_type" {
  default = "n1-standard-2"
}
