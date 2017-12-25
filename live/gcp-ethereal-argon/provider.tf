provider "google" {
  credentials = "${file("credentials.json")}"
  project = "ethereal-argon-186217"
  region  = "europe-west1-d"
}
