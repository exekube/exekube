provider "google" {
  credentials = "${file("/exekube/credentials.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}
