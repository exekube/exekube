# ------------------------------------------------------------------------------
# Manage a generic Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count      = "${var.release["enabled"]}"
  depends_on = ["kubernetes_secret.basic_auth"]

  repository = "${var.release["chart_repo"]}"
  chart      = "${var.release["chart_name"]}"
  version    = "${var.release["chart_version"]}"

  name   = "${var.release["release_name"]}"
  values = "${data.template_file.release_values.rendered}"

  provisioner "local-exec" {
    command = "${var.release["post_hook"]}"
  }
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${format("%s/%s", path.module, var.release["release_values"])}")}"

  vars {
    domain_name = "${var.release["domain_name"]}"
  }
}

resource "kubernetes_secret" "basic_auth" {
  count = "${var.release["basic_auth"] == "" ? 0 : 1}"

  metadata {
    name = "${replace(var.release["basic_auth"], ".", "-")}"
  }

  data {
    auth = "${file("${format("%s/%s", path.module, var.release["basic_auth"])}")}"
  }

  type = "Opaque"
}
