/*
resource "google_service_account" {}
resource "google_service_account_key" {}
resource "google_project_iam_custom_role" {}
resource "google_project_iam_policy" {}
resource "google_project_services" {}
data "google_iam_policy" {}
*/
// enable IAM API for project
/*
resource "google_project_service" "iam" {
  project = "${var.gcp_project}"
  service = "iam.googleapis.com"

  provisioner "local-exec" {
    command = "sleep 20"
  }
}

// create a service_account
resource "google_service_account" "alice" {
  account_id   = "alice-doe"
  display_name = "Alice"
  depends_on   = ["google_project_service.iam"]
}

// create a key pair for alice sa
resource "google_service_account_key" "alice" {
  service_account_id = "${google_service_account.alice.id}"
  depends_on         = ["google_project_service.iam"]
}

// output public key to make sure it works
output "alice_public_key" {
  value = "${google_service_account_key.alice.public_key}"
}

// create IAM policy for the whole project
resource "google_project_iam_policy" "main" {
  project     = "${var.gcp_project}"
  policy_data = "${data.google_iam_policy.main.policy_data}"
  depends_on  = ["google_project_service.iam"]
}

// create a policy (a collection of bindings)
data "google_iam_policy" "main" {
  binding {
    role = "roles/owner"

    members = [
      "serviceAccount:${google_service_account.alice.email}",
    ]
  }
}
*/

