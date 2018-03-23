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

variable "keyring_name" {
  default = "keyring"
}

variable "storage_location" {
  default = "europe-west1"
}

variable "encryption_keys" {
  description = "Names of encryption keys to create (a storage bucket will also be created for each)"

  default = []
}
