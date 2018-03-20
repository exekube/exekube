# ------------------------------------------------------------------------------
# GOOGLE CLOUD PROJECT
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "The id of the project we created via the gcp-project module"
}

variable "terraform_credentials" {}
variable "product_env" {}

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
  type        = "list"
  description = "A map for setting cryptographic keys"

  # Format:
  # crypto_key = "comma-separated crypto_key users"
  # "team1" = "user:jon@example.com,user:anna@example.com,user:maria@example.com"
  default = []
}

variable "crypto_keys_users" {
  type = "list"

  default = []
}
