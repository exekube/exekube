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
# GOOGLE STACKDRIVER EXPORT
# ------------------------------------------------------------------------------

resource "google_storage_bucket" "exported-logs" {
  count         = "${var.exported_logs_encryption_key == "" ? 1 : 0}"
  name          = "${var.project_id}-exported-logs"
  force_destroy = true
  storage_class = "${var.exported_logs_storage_class}"
  location      = "${var.exported_logs_storage_region}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = "${var.exported_logs_expire_after}"
    }
  }
}

resource "google_storage_bucket" "exported-logs-custom-encryption" {
  count         = "${var.exported_logs_encryption_key == "" ? 0 : 1}"
  name          = "${var.project_id}-exported-logs"
  force_destroy = true
  storage_class = "${var.exported_logs_storage_class}"
  location      = "${var.exported_logs_storage_region}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = "${var.exported_logs_expire_after}"
    }
  }

  encryption {
    default_kms_key_name = "${var.exported_logs_encryption_key}"
  }
}

resource "google_logging_project_sink" "my-export" {
  count       = "${var.exported_logs_encryption_key == "" ? length(var.exports) : 0}"
  count       = "${}"
  name        = "${element(keys(var.exports), count.index)}"
  destination = "storage.googleapis.com/${google_storage_bucket.exported-logs.name}"

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
              element(values(var.exports), count.index),
              "__var.project_id__",
              "${var.project_id}"
            )}"

  unique_writer_identity = true
}

resource "google_logging_project_sink" "my-export-custom-encryption" {
  count       = "${var.exported_logs_encryption_key == "" ? 0 : length(var.exports)}"
  name        = "${element(keys(var.exports), count.index)}"
  destination = "storage.googleapis.com/${google_storage_bucket.exported-logs-custom-encryption.name}"

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
              element(values(var.exports), count.index),
              "__var.project_id__",
              "${var.project_id}"
            )}"

  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to
# the bucket.
resource "google_project_iam_binding" "exported-logs-writer" {
  role = "roles/storage.objectCreator"

  members = [
    "${google_logging_project_sink.my-export.*.writer_identity}",
  ]
}
