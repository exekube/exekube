# ------------------------------------------------------------------------------
# TERRAFORM ADMIN PROJECT
# ------------------------------------------------------------------------------

variable "terraform_credentials" {
  description = "Terraform service account key to use for initial setup"
}

# ------------------------------------------------------------------------------
# PRODUCT ENVIRONMENT PROJECT
# ------------------------------------------------------------------------------

/*
variable "default_region" {
  description = "default GCP region"
  default     = "europe-west1"
}

variable "default_zone" {
  description = "default GCP zone"
  default     = "europe-west1-d"
}
*/

variable "product_name" {
  description = "Base name used for creating new projects"
}

variable "product_env" {
  description = "The environment prefix for the project [ dev | stg | test | prod ]"
}

variable "organization_id" {
  description = "Organization under which the project will be created"
}

variable "billing_id" {
  description = "The billing id for the project"
}

variable "project_services" {
  type        = "list"
  description = "The APIs to enable for the project"

  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudkms.googleapis.com",
  ]
}

# ------------------------------------------------------------------------------
# NETWORKING RESOURCES
# ------------------------------------------------------------------------------

variable "cluster_subnets" {
  type        = "map"
  description = "A map of index to a comma separated list of `region,nodes-subnet,pods-subnet,services-subnet` string."

  default = {
    # index = "region,nodes-subnet,pods-subnet,services-subnet"
    "0" = "europe-west1,10.16.0.0/20,10.17.0.0/16,10.18.0.0/16"
  }
}

# ------------------------------------------------------------------------------
# SECRETS MANAGEMENT AND KMS
# ------------------------------------------------------------------------------

variable "secret_store_location" {
  default = "europe-west1"
}

variable "keyring_admins" {
  type        = "list"
  description = "Users who have full controll over the keyring"
  default     = []
}

variable "keyring_users" {
  type        = "list"
  description = "Users who can encrypt and decrypt keys in the keyring"
  default     = []
}

variable "crypto_keys" {
  type        = "map"
  description = "A map for setting cryptographic keys and access to them"

  # Format:
  # crypto_key = "comma-separated crypto_key users"
  # "team1" = "user:jon@example.com,user:anna@example.com,user:maria@example.com"
  default = {}
}
