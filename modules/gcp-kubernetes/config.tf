terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "random" {
  version = "~> 1.1"
}

provider "google" {
  project     = "${var.terraform_project}"
  credentials = "${var.terraform_credentials}"
  region      = "${var.gcp_region}"
  zone        = "${var.gcp_zone}"
}
