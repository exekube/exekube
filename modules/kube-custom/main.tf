terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "kubernetes" {}

# ------------------------------------------------------------------------------
# Add private Helm repository
# ------------------------------------------------------------------------------

resource "helm_repository" "swarm_charts" {
  name = "swarm-charts"
  url = "https://${var.chartmuseum_username}:${var.chartmuseum_password}@charts.swarm.pw"
}

# ------------------------------------------------------------------------------
# Install custom Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "rails_app" {
  count      = "${var.rails_app_enabled}"
  name       = "${var.rails_app_release_name}"
  repository = "${helm_repository.swarm_charts.metadata.0.name}"
  chart      = "rails-app"
  values     = "${file("${var.rails_app_release_values}")}"
}
