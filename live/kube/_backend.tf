// use a Google Cloud Storage bucket for Terraform remote state
terraform {
  backend "gcs" {
    bucket  = "helm-releases-terraform-state"
    project = "ethereal-argon-186217"
    prefix  = "terraform/state"
  }
}
