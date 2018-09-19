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
  count  = "${length(var.exclusions)}"
  name   = "${element(keys(var.exclusions), count.index)}"
  filter = "${element(values(var.exclusions), count.index)}"
}
