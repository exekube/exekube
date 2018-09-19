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

variable "exclusions" {
  type = "map"
  description = "Map of Stackdriver exclusion rules where keys are names of rules and values are filters implementing those rules"

  # Example: {"drop-all-foos" = "textPayload:\"foo\"}
  default = {}
}
