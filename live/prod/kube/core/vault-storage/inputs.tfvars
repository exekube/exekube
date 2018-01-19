# ------------------------------------------------------------------------------
# Service account for Vault to access the bucket
# ------------------------------------------------------------------------------

account_id = "vault-service-account"

display = "Vault service account"

project = "ethereal-argon-186217"

role = "roles/storage.admin"

# ------------------------------------------------------------------------------
# Bucket inputs
# ------------------------------------------------------------------------------

gcs_bucket_name = "vault-data"

gcs_bucket_location = "eu"

gcs_bucket_storage_class = "MULTI_REGIONAL"

gcs_bucket_force_destroy = "true"
