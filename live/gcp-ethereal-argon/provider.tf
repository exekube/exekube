provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "ethereal-argon-186217"
  region      = "europe-west1-d"
}

// we use same default credentials that are used for `kubectl`
provider "kubernetes" {}

// we use same default credentials that are used for `kubectl`
provider "helm" {}
