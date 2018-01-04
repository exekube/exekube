terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "kubernetes" {}

# ------------------------------------------------------------------------------
# Add private Helm repository
# ------------------------------------------------------------------------------

resource "helm_repository" "chart_repo" {
  name = "chart-repository"
  url  = "https://${var.chartmuseum_username}:${var.chartmuseum_password}@${var.chartmuseum_domain_name}"
}

# ------------------------------------------------------------------------------
# Install custom Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "rails_app" {
  count      = "${var.rails_app_enabled}"
  name       = "${var.rails_app_release_name}"
  repository = "${helm_repository.chart_repo.metadata.0.name}"
  chart      = "rails-app"
  values     = "${data.template_file.rails_app.rendered}"
}

data "template_file" "rails_app" {
  template = "${file("${var.rails_app_release_values}")}"

  vars {
    rails_app_domain_name = "${var.rails_app_domain_name}"
  }
}
