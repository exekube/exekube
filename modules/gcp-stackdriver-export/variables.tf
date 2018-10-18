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

variable "exports" {
  type        = "map"
  description = "Map of Stackdriver export rules where keys are names of rules and values are filters implementing those rules. (__var.project_id__ is replaced with $var.project_id at runtime -- useful for matching logName exactly for efficient filtering.)"

  # Example: {"export-all-foo" = "logName=\"projects/__var.project_id__/logs/foo\"}
  default = {}
}

variable "exported_logs_force_destroy" {
  description = "If 'true', the exported logs bucket will be destroyed on 'terragrunt destroy' or (NOTE!) on certain kinds of reconfiguration, e.g. changing storage class from REGIONAL to NEARLINE. Use caution when setting to 'true'."
  default     = "false"
}

variable "exported_logs_storage_class" {
  description = "Storage class for bucket containing exported logs."
  default     = "REGIONAL"
}

variable "exported_logs_storage_region" {
  description = "Region for bucket containing exported logs."
  default     = "europe-north1-a"
}

variable "exported_logs_expire_after" {
  description = "Exported logs are deleted from the bucket after this many days."
  default     = "14"
}

variable "exported_logs_encryption_key" {
  description = "Name of a KMS key to use (e.g. projects/my-project/locations/global/keyRings/keyring/cryptoKeys/gcp-stackdriver-export). Empty string means use Google's default encryption."
  default     = ""
}
