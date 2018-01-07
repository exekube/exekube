terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"
}
