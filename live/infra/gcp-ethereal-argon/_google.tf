variable "gcp_project" {}

provider "google" {
  credentials = "${file("/exekube/credentials.json")}"
  project     = "${var.gcp_project}"
  region      = "europe-west1-d"
}
