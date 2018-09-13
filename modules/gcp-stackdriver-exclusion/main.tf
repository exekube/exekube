# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDER CONFIG
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  project     = "${var.project_id}"
  credentials = "${var.serviceaccount_key}"
}

# ------------------------------------------------------------------------------
# GOOGLE STACKDRIVER EXCLUSION
# ------------------------------------------------------------------------------

resource "google_logging_project_exclusion" "my-exclusion" {
  name        = "${var.exclusion_name}"
  description = "${var.exclusion_description}"
  filter      = "${var.exclusion_filter}"
}
