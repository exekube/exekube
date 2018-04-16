# ------------------------------------------------------------------------------
# PROVIDER
# ------------------------------------------------------------------------------

provider "helm" {
  namespace  = "${var.tiller_namespace}"
  enable_tls = true
  insecure   = false
  debug      = true

  ca_certificate     = "${file("${var.client_auth}/ca.cert.pem")}"
  client_certificate = "${file("${var.client_auth}/helm.cert.pem")}"
  client_key         = "${file("${var.client_auth}/helm.key.pem")}"
}

# ------------------------------------------------------------------------------
# HELM RELEASE
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count = "${var.disable_release ? 0 : 1}"

  repository = "${var.chart_repo}"
  chart      = "${var.chart_name}"
  version    = "${var.chart_version}"

  name      = "${var.release_name}"
  namespace = "${var.release_namespace}"

  values = [
    "${data.template_file.release_values.rendered}",
  ]

  force_update     = false
  devel            = true
  disable_webhooks = false
  timeout          = 500
  reuse            = true
  recreate_pods    = false
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${var.release_values}")}"

  vars {
    domain_name      = "${var.domain_name}"
    load_balancer_ip = "${var.load_balancer_ip}"
  }
}
