# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDER CONFIG
# ------------------------------------------------------------------------------

terraform {
  backend "gcs" {}
}

provider "kubernetes" {}

# ------------------------------------------------------------------------------
# Create a kubernetes namespace
# ------------------------------------------------------------------------------

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "${var.namespace_name}"
  }
}
