# ------------------------------------------------------------------------------
# Add private Helm repository
# ------------------------------------------------------------------------------

resource "helm_repository" "chart_repo" {
  name = "chart-repository"
  url  = "https://${var.chartmuseum_repo["username"]}:${var.chartmuseum_repo["password"]}@${var.chartmuseum_repo["domain_name"]}"
}

# ------------------------------------------------------------------------------
# Install custom Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "rails_app" {
  count      = "${var.rails_app["enabled"]}"
  name       = "${var.rails_app["release_name"]}"
  repository = "${helm_repository.chart_repo.metadata.0.name}"
  chart      = "rails-app"
  values     = "${data.template_file.rails_app.rendered}"
}

data "template_file" "rails_app" {
  template = "${file("${format("%s/%s", path.module, var.rails_app["values_file"])}")}"

  vars {
    domain_name = "${var.rails_app["domain_name"]}"
  }
}
