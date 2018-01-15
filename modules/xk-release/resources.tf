# ------------------------------------------------------------------------------
# Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count      = "${var.release_spec["enabled"]}"
  depends_on = ["kubernetes_secret.basic_auth", "kubernetes_secret.docker_credentials"]

  repository = "${var.release_spec["chart_repo"]}"
  chart      = "${var.release_spec["chart_name"]}"
  version    = "${var.release_spec["chart_version"]}"

  name   = "${var.release_spec["release_name"]}"
  values = "${data.template_file.release_values.rendered}"

  reuse_values     = false
  force_update     = false
  disable_webhooks = false
  timeout          = 300

  wait          = true
  recreate_pods = false

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

# ------------------------------------------------------------------------------
# Point DNS zones to our cloud load balancer IP address
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
# Basic auth Kubernetes secret
# ------------------------------------------------------------------------------

locals {
  basic_auth_secret_name = "${replace(basename(var.basic_auth_secret["file"]), ".", "-")}"
}

resource "kubernetes_secret" "basic_auth" {
  count = "${var.basic_auth_secret["file"] == "" ? 0 : 1}"

  metadata {
    name = "${local.basic_auth_secret_name}"
  }

  data {
    auth = "${file("${format("%s/%s", path.module, var.basic_auth_secret["file"])}")}"
  }

  type = "Opaque"
}

# ------------------------------------------------------------------------------
# dockercfg to use as imagePullSecret (dockercfg, dockerconfigjson)
# ------------------------------------------------------------------------------

locals {
  dockercfg_auth = "${var.registry_auth["username"]}:${var.registry_auth["password"]}"
}

resource "kubernetes_secret" "docker_credentials" {
  count = "${var.release_spec["release_name"] == "docker-registry" ? 1 : 0}"

  metadata {
    name = "registry-dockercfg"
  }

  data {
    ".dockercfg" = <<EOF
{"${var.release_spec["domain_name"]}":{"username":"${var.registry_auth["username"]}","password":"${var.registry_auth["password"]}","email":"","auth":"${base64encode(local.dockercfg_auth)}"}}
EOF
  }

  type = "kubernetes.io/dockercfg"
}

# ------------------------------------------------------------------------------
# Private Helm repo
# ------------------------------------------------------------------------------

resource "helm_repository" "private" {
  depends_on = ["helm_release.release"]
  count      = "${var.release_spec["release_name"] == "chartmuseum" ? 1 : 0}"

  name = "private"
  url  = "https://${var.chartrepo_auth["username"]}:${var.chartrepo_auth["password"]}@${var.release_spec["domain_name"]}"

  provisioner "local-exec" {
    command = "helm repo update"
  }
}
