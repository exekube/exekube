terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "google" {
  project     = "${var.terraform_project}"
  credentials = "${var.terraform_credentials}"
  zone        = "${var.gcp_region}"
  region      = "${var.gcp_zone}"
}
