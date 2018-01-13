# ------------------------------------------------------------------------------
# Use LoadBalancer IP to create a CloudFlare DNS record
# ------------------------------------------------------------------------------

resource "cloudflare_record" "web" {
  count = "${var.release_spec["release_name"] == "ingress-controller" ? length(var.cluster_dns_zones) : 0}"

  domain   = "${element(var.cluster_dns_zones, count.index)}"
  name     = "*"
  value    = "${data.kubernetes_service.ingress_controller.load_balancer_ingress.0.ip}"
  type     = "A"
  ttl      = 120
  proxied  = false
  priority = 0
}

data "kubernetes_service" "ingress_controller" {
  depends_on = ["helm_release.release"]
  count      = "${var.release_spec["release_name"] == "ingress-controller" ? 1 : 0}"

  metadata {
    name = "ingress-controller-nginx-ingress-controller"
  }
}

# ------------------------------------------------------------------------------
# Add private ChertMuseum repo
# ------------------------------------------------------------------------------

resource "helm_repository" "private" {
  depends_on = ["helm_release.release"]
  count      = "${var.release_spec["release_name"] == "chartmuseum" ? 1 : 0}"

  name = "private"
  url  = "https://${var.release_spec["chartrepo_username"]}:${var.release_spec["chartrepo_password"]}@${var.release_spec["domain_name"]}"

  provisioner "local-exec" {
    command = "helm repo update"
  }
}

# ------------------------------------------------------------------------------
# Manage a generic Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count      = "${var.release_spec["enabled"]}"
  depends_on = ["kubernetes_secret.basic_auth", "kubernetes_secret.docker_credentials"]

  repository = "${var.release_spec["chart_repo"]}"
  chart      = "${var.release_spec["chart_name"]}"
  version    = "${var.release_spec["chart_version"]}"

  name   = "${var.release_spec["release_name"]}"
  values = "${data.template_file.release_values.rendered}"

  provisioner "local-exec" {
    command = "${var.release_spec["post_hook"]}"
  }
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${format("%s/%s", path.module, var.release_spec["release_values"])}")}"

  vars {
    domain_name = "${var.release_spec["domain_name"]}"
  }
}

resource "kubernetes_secret" "basic_auth" {
  count = "${var.release_spec["basic_auth"] == "" ? 0 : 1}"

  metadata {
    name = "${replace(var.release_spec["basic_auth"], ".", "-")}"
  }

  data {
    auth = "${file("${format("%s/%s", path.module, var.release_spec["basic_auth"])}")}"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "docker_credentials" {
  count = "${var.release_spec["pull_secret"] == "" ? 0 : 1}"

  metadata {
    name = "${replace(var.release_spec["pull_secret"], ".", "-")}"
  }

  data {
    ".dockercfg" = "${file("${format("%s/%s", path.module, var.release_spec["pull_secret"])}")}"
  }

  type = "kubernetes.io/dockercfg"
}
