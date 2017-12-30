variable "gcp_project" {}
variable "gcp_zone" {
  default = "europe-west1-d"
}

provider "google" {
  credentials = "${file("/exekube/credentials.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_zone}"
}
