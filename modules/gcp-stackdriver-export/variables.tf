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

  # Example: {"exclude-all-foo" = "logName=\"projects/__var.project_id__/logs/foo\"}
  default = {}
}
