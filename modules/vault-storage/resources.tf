data "google_client_config" "default" {}

resource "google_project_service" "iam" {
  project = "${var.project}"

  service = "iam.googleapis.com"
}

resource "google_service_account" "default" {
  account_id   = "${var.account_id}"
  display_name = "${var.display_name}"
  project      = "${var.project}"
}

resource "google_project_iam_policy" "default" {
  project     = "${var.project}"
  policy_data = "${data.google_iam_policy.default.policy_data}"
}

data "google_iam_policy" "default" {
  binding {
    role = "${var.role}"

    members = [
      "serviceAccount:${google_service_account.default.email}",
    ]
  }
}

resource "google_storage_bucket" "vault_storage_backend" {
  name          = "${var.gcs_bucket_name}"
  project       = "${var.project}"
  storage_class = "${var.gcs_bucket_storage_class}"
  force_destroy = "${var.gcs_bucket_force_destroy}"
}
