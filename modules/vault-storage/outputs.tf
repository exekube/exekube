output "service_account_email" {
  value       = "${google_service_account.default.email}"
  description = "The e-mail address of the service account."
}

output "service_account_name" {
  value       = "${google_service_account.default.name}"
  description = "The fully-qualified name of the service account."
}

output "service_account_private_key" {
  value = "${google_service_account_key.default.private_key}"
}

output "unique_id" {
  value       = "${google_service_account.default.unique_id}"
  description = "The unique id of the service account."
}

output "iam_policy_etag" {
  value       = "${google_project_iam_policy.default.etag}"
  description = "The etag of the project's IAM policy."
}
