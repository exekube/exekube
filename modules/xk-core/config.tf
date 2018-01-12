terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "cloudflare" {
  email = "${var.cloudflare["email"]}"
  token = "${var.cloudflare["token"]}"
}

provider "helm" {}

provider "kubernetes" {}
