# ---------------------------------------------------------------------------------------------------------------------
# CREATE A GOOGLE STORAGE BUCKET TO USE AS A VAULT STORAGE BACKEND
# ---------------------------------------------------------------------------------------------------------------------

variable "account_id" {
  description = "The service account ID."
}

variable "display_name" {
  description = "The display name for the service account."
  default     = "Managed by Terraform"
}

variable "project" {
  description = "GCE project name"
  default     = ""
}

variable "role" {
  description = "The role/permission that will be granted to the members."
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A GOOGLE STORAGE BUCKET TO USE AS A VAULT STORAGE BACKEND
# ---------------------------------------------------------------------------------------------------------------------

variable "gcs_bucket_name" {
  description = "The name of the Google Storage Bucket where Vault secrets will be stored."
}

variable "gcs_bucket_location" {
  description = "The location of the Google Storage Bucket where Vault secrets will be stored. For details, see https://goo.gl/hk63jH."
}

variable "gcs_bucket_storage_class" {
  description = "The Storage Class of the Google Storage Bucket where Vault secrets will be stored. Must be one of MULTI_REGIONAL, REGIONAL, NEARLINE, or COLDLINE. For details, see https://goo.gl/hk63jH."
}

# Google Storage Bucket Settings

variable "gcs_bucket_force_destroy" {
  description = "If true, Terraform will delete the Google Cloud Storage Bucket even if it's non-empty. WARNING! Never set this to true in a production setting. We only have this option here to facilitate testing."
  default     = false
}

variable "gcs_bucket_predefined_acl" {
  description = "The canned GCS Access Control List (ACL) to apply to the GCS Bucket. For a full list of Predefined ACLs, see https://cloud.google.com/storage/docs/access-control/lists."
  default     = "projectPrivate"
}
