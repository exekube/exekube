# ------------------------------------------------------------------------------
# Manage a generic Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count = "${var.release["enabled"]}"

  repository = "${var.release["chart_repo"]}"
  chart      = "${var.release["chart_name"]}"
  version    = "${var.release["chart_version"]}"

  name   = "${var.release["release_name"]}"
  values = "${data.template_file.release_values.rendered}"
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${format("%s/%s", path.module, var.release["release_values"])}")}"

  vars {
    domain_name = "${var.release["domain_name"]}"
  }
}
