terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "cloudflare" {
  email = "${var.cloudflare["email"]}"
  token = "${var.cloudflare["token"]}"
}

provider "kubernetes" {}
