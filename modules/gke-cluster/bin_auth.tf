# Since we sometimes use ADCs, and since the binaryauthorization API does not
# allow ADCs, we need a dedicated SA to manage binary auth. See GPII-3860.
data "google_service_account_access_token" "bin-auth" {
  count    = "${var.enable_binary_authorization ? 1 : 0}"
  provider = "google-beta"

  target_service_account = "gke-cluster-bin-auth@${var.project_id}.iam.gserviceaccount.com"
  scopes                 = ["cloud-platform"]
  lifetime               = "300s"
}

provider "google-beta" {
  alias        = "bin-auth"
  access_token = "${data.google_service_account_access_token.bin-auth.access_token}"
}

resource "google_binary_authorization_policy" "policy" {
  count    = "${var.enable_binary_authorization ? 1 : 0}"
  provider = "google-beta.bin-auth"
  project  = "${var.project_id}"

  default_admission_rule {
    evaluation_mode  = "${var.binary_authorization_evaluation_mode}"
    enforcement_mode = "${var.binary_authorization_enforcement_mode}"
  }

  admission_whitelist_patterns {
    name_pattern = "${var.binary_authorization_admission_whitelist_patterns}"
  }
}
