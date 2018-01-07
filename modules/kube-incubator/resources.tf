# ------------------------------------------------------------------------------
# Add private Helm repository
# ------------------------------------------------------------------------------

resource "helm_repository" "chart_repository" {
  name = "incubator-2"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"

  provisioner "local-exec" {
    command = "sleep 10 && helm repo update"
  }
}

# ------------------------------------------------------------------------------
# Install incubator Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "istio" {
  count = "${var.istio["enabled"]}"

  # depends_on = ["helm_repository.chart_repo"]

  name       = "${var.istio["release_name"]}"
  repository = "incubator-2"
  chart      = "istio"
  version    = "0.2.12-chart3"
  values     = "${data.template_file.istio.rendered}"
}

data "template_file" "istio" {
  template = "${file("${format("%s/%s", path.module, var.istio["values_file"])}")}"

  vars {}
}
