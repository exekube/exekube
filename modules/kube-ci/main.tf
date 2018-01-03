terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "kubernetes" {}

# ---------------------------------------------------------------------------------------------------------------------
# INSTALL CONTINOUS INTEGRATION TOOLS VIA HELM CHARTS
# ---------------------------------------------------------------------------------------------------------------------

resource "helm_release" "jenkins_dev" {
  # count      = 1

  name       = "jenkins-dev"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${file("${var.helm_values_jenkins}")}"
}
