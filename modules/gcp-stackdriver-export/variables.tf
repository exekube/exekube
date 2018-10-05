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

variable "exported_logs_storage_class" {
  default = "REGIONAL"
}

variable "exported_logs_storage_region" {
  default = "europe-north1-a"
}

variable "exported_logs_expire_after" {
  default = "14"
}
