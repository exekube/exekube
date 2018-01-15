terraform {
  backend "gcs" {}
}

provider "helm" {}

provider "cloudflare" {
  email = "${var.cloudflare_auth["email"]}"
  token = "${var.cloudflare_auth["token"]}"
}

provider "kubernetes" {}
