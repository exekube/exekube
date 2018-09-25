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
  # logName is a common thing to filter on. Per
  # https://cloud.google.com/logging/docs/view/advanced-filters#minimize_global_and_substring_searches,
  # it is best to match on an exact string. Doing so requires knowing
  # var.project_id (since logName starts with "projects/my-project-id/").
  # Neither Terraform variables (var.project_id) nor their environment variable
  # cousins (TF_VAR_project_id) are availble from terraform.tfvars, where an
  # instance of this module declares its filters. Hence, this workaround to
  # replace the string "__var.project_id__" with the value of ${var.project_id}
  # at runtime.
  filter = "${replace(
              element(values(var.exclusions), count.index),
              "__var.project_id__",
              "${var.project_id}"
            )}"
}
