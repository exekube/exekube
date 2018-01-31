# ------------------------------------------------------------------------------
# Service account for Vault to access the bucket
# ------------------------------------------------------------------------------

account_id = "vault-service-account"

display = "Vault service account"

role = "roles/storage.admin"

vault_sa_json_privkey_path = "/exekube/live/prod/kube/core/vault/release/secrets/gcp-credentials/vault.json"

# ------------------------------------------------------------------------------
# Bucket inputs
# ------------------------------------------------------------------------------

gcs_bucket_name = "gcp-credentials-vault"

gcs_bucket_location = "eu"

gcs_bucket_storage_class = "MULTI_REGIONAL"

gcs_bucket_force_destroy = "true"
