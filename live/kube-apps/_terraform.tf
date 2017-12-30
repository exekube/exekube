// use a Google Cloud Storage bucket for Terraform remote state
terraform {
  backend "gcs" {
    bucket  = "ethereal-argon-terraform-state"
    project = "ethereal-argon-186217"
    prefix  = "terraform/state/kube-apps"
  }
}
