variable "terraform_project" {
  description = "Project we use for managing Terraform and keep its remote state"
}

variable "terraform_credentials" {
  description = "JSON key for the Terraform service account"
}

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

variable "crypto_keys" {
  type = "list"
}
