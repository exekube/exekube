data "google_client_config" "default" {}

resource "google_project_service" "iam" {
  project            = "${var.gcp_project}"
  disable_on_destroy = false

  service = "iam.googleapis.com"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "google_project_service" "cloudresourcemanager" {
  project            = "${var.gcp_project}"
  disable_on_destroy = false

  service = "cloudresourcemanager.googleapis.com"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "google_service_account" "default" {
  depends_on = ["google_project_service.iam"]

  account_id   = "${var.account_id}"
  display_name = "${var.display_name}"
  project      = "${var.gcp_project}"
}

resource "google_service_account_key" "default" {
  service_account_id = "${google_service_account.default.id}"

  public_key_type  = "TYPE_X509_PEM_FILE"
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"

  provisioner "local-exec" {
    command = <<EOF
echo ${google_service_account_key.default.private_key} | \
base64 -d > ${var.vault_sa_json_privkey_path} \
&& chmod 0600 ${var.vault_sa_json_privkey_path}
EOF
  }
}

resource "google_project_iam_policy" "default" {
  depends_on = ["google_project_service.cloudresourcemanager"]

  project     = "${var.gcp_project}"
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
  project       = "${var.gcp_project}"
  location      = "${var.gcs_bucket_location}"
  storage_class = "${var.gcs_bucket_storage_class}"
  force_destroy = "${var.gcs_bucket_force_destroy}"
}
