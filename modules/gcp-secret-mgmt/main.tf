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
# PROJECT KEY RING
# ------------------------------------------------------------------------------

resource "google_kms_key_ring" "key_ring" {
  name     = "${var.keyring_name}"
  location = "global"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# ------------------------------------------------------------------------------
# CRYPTO KEYS AND STORAGE BUCKETS
# ------------------------------------------------------------------------------

resource "google_kms_crypto_key" "encryption_keys" {
  count = "${length(var.encryption_keys)}"

  name     = "${element(var.encryption_keys, count.index)}"
  key_ring = "${google_kms_key_ring.key_ring.id}"
}

resource "google_storage_bucket" "gcs_buckets" {
  count = "${length(var.encryption_keys)}"

  name          = "${var.project_id}-${element(var.encryption_keys, count.index)}-secrets"
  storage_class = "REGIONAL"
  location      = "${var.storage_location}"
  force_destroy = true
}

# ------------------------------------------------------------------------------
# TEMPLATE FOR GIVING GRANULAR ACCESS
# ------------------------------------------------------------------------------


/*
# Full control over the kerring and all encryption keys in it
resource "google_kms_key_ring_iam_binding" "keyring_admins" {
  key_ring_id = ""
  role        = "roles/cloudkms.admin"

  members = []
}

# Access to all encryption keys
resource "google_kms_key_ring_iam_binding" "keyring_users" {
  key_ring_id = ""
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = []
}

resource "google_kms_crypto_key_iam_binding" "cryptokey_users" {
  crypto_key_id = ""
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = []
}


# Allow fetching and pushing secrets in the bucket
resource "google_storage_bucket_iam_binding" "bucket_admins" {
  bucket = ""

  role = "roles/storage.objectAdmin"

  members = []
}
*/

