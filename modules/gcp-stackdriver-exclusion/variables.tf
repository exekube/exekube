# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "Project where resources will be created"
}

variable "serviceaccount_key" {
  description = "Service account key for the project"
}

variable "exclusion_name" {
  description = "Name of Stackdriver exclusion rule"
}

variable "exclusion_description" {
  description = "Description of Stackdriver exclusion rule"
}

variable "exclusion_filter" {
  description = "Stackdriver filter defining what will be excluded"
}
