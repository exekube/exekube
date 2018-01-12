resource "helm_repository" "private" {
  count = "${var.release["release_name"] == "chartmuseum" ? 1 : 0}"

  name = "private"
  url  = "https://${var.release["chartrepo_username"]}:${var.release["chartrepo_password"]}@${var.release["domain_name"]}"
}

# ------------------------------------------------------------------------------
# Manage a generic Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count      = "${var.release["enabled"]}"
  depends_on = ["kubernetes_secret.basic_auth", "kubernetes_secret.docker_credentials"]

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

resource "kubernetes_secret" "docker_credentials" {
  count = "${var.release["pull_secret"] == "" ? 0 : 1}"

  metadata {
    name = "${replace(var.release["pull_secret"], ".", "-")}"
  }

  data {
    ".dockercfg" = "${file("${format("%s/%s", path.module, var.release["pull_secret"])}")}"
  }

  type = "kubernetes.io/dockercfg"
}
