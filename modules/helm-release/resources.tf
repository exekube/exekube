# ------------------------------------------------------------------------------
# Run a pre_hook via the null_resource provisioner
# ------------------------------------------------------------------------------

resource "null_resource" "pre_hook" {
  count = "${var.release_spec["enabled"]}"

  provisioner "local-exec" {
    command = "${var.pre_hook["command"]}"
  }
}

# ------------------------------------------------------------------------------
# Helm release
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count = "${var.release_spec["enabled"]}"

  depends_on = [
    "null_resource.pre_hook",
    "null_resource.basic_auth_secret",
    "kubernetes_secret.docker_credentials",
  ]

  repository = "${var.release_spec["chart_repo"]}"
  chart      = "${var.release_spec["chart_name"]}"
  version    = "${var.release_spec["chart_version"]}"

  name   = "${var.release_spec["release_name"]}"
  values = "${data.template_file.release_values.rendered}"

  reuse_values     = false
  force_update     = false
  disable_webhooks = false
  timeout          = 500

  wait          = true
  recreate_pods = false

  provisioner "local-exec" {
    command = "${var.post_hook["command"]}"
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
  count = "${var.release_spec["release_name"] == "ingress-controller" && var.release_spec["enabled"] ? length(var.cluster_dns_zones) : 0}"

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

data "local_file" "basic_auth_username" {
  count      = "${var.release_spec["enabled"] && var.basic_auth["secret_name"] != "" ? 1 : 0}"
  depends_on = ["null_resource.pre_hook"]

  filename = "${format("%s/%s", path.module, var.basic_auth["username_file"])}"
}

data "local_file" "basic_auth_password" {
  count      = "${var.release_spec["enabled"] && var.basic_auth["secret_name"] != "" ? 1 : 0}"
  depends_on = ["null_resource.pre_hook"]

  filename = "${format("%s/%s", path.module, var.basic_auth["password_file"])}"
}

resource "null_resource" "basic_auth_secret" {
  count      = "${var.release_spec["enabled"] && var.basic_auth["secret_name"] != "" ? 1 : 0}"
  depends_on = ["null_resource.pre_hook"]

  provisioner "local-exec" {
    command = <<EOF
kubectl create secret generic ${var.basic_auth["secret_name"]} \
--from-literal=auth=$( \
echo ${data.local_file.basic_auth_password.content} \
| htpasswd -i -n \
${data.local_file.basic_auth_username.content} \
)
EOF
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete secret ${var.basic_auth["secret_name"]}"
  }
}

# ------------------------------------------------------------------------------
# dockercfg to use as imagePullSecret (dockercfg, dockerconfigjson)
# ------------------------------------------------------------------------------

resource "kubernetes_secret" "docker_credentials" {
  count = "${var.release_spec["enabled"] && var.release_spec["release_name"] == "docker-registry" ? 1 : 0}"

  metadata {
    name = "registry-dockercfg"
  }

  data {
    ".dockercfg" = <<EOF
{"${var.release_spec["domain_name"]}":{"username":"${data.local_file.basic_auth_username.content}","password":"${data.local_file.basic_auth_password.content}","email":"","auth":"${base64encode(format("%s:%s", data.local_file.basic_auth_username.content, data.local_file.basic_auth_password.content))}"}}
EOF
  }

  type = "kubernetes.io/dockercfg"
}

# ------------------------------------------------------------------------------
# Private Helm repo
# ------------------------------------------------------------------------------

resource "helm_repository" "private" {
  depends_on = ["helm_release.release"]
  count      = "${var.release_spec["enabled"] && var.release_spec["release_name"] == "chartmuseum" ? 1 : 0}"

  name = "private"
  url  = "https://${data.local_file.basic_auth_username.content}:${data.local_file.basic_auth_password.content}@${var.release_spec["domain_name"]}"

  provisioner "local-exec" {
    command = "helm repo update"
  }
}
