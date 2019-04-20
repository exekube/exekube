output "storage_buckets" {
  value = ["${google_storage_bucket.gcs_buckets.*.name}"]
}

output "encryption_keys" {
  value = "${zipmap(var.encryption_keys, google_kms_crypto_key.encryption_keys.*.id)}"
}

output "keyring_id" {
  value = "${google_kms_key_ring.key_ring.id}"
}
