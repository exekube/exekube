# ------------------------------------------------------------------------------
# Jenkins release
# ------------------------------------------------------------------------------

resource "helm_release" "jenkins" {
  count = "${var.jenkins["enabled"]}"

  name       = "${var.jenkins["release_name"]}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${data.template_file.jenkins.rendered}"
}

# Parsed (interpolated) YAML values file
data "template_file" "jenkins" {
  template = "${file("${format("%s/%s", path.module, var.jenkins["values_file"])}")}"

  vars {
    domain_name = "${var.jenkins["domain_name"]}"
  }
}

# ------------------------------------------------------------------------------
# Chartmuseum release
# ------------------------------------------------------------------------------

resource "helm_release" "chartmuseum" {
  depends_on = ["helm_release.jenkins"]
  count      = "${var.chartmuseum["enabled"]}"

  name       = "${var.chartmuseum["release_name"]}"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "chartmuseum"
  values     = "${data.template_file.chartmuseum.rendered}"

  provisioner "local-exec" {
    command = <<EOF
sleep 10 \
&& cd /exekube/charts/rails-app \
&& curl \
-u ${var.chartmuseum["username"]}:${var.chartmuseum["password"]} \
--data-binary "@rails-app-0.1.0.tgz" \
https://${var.chartmuseum["domain_name"]}/api/charts \
&& helm repo update
EOF
  }
}

# Parsed (interpolated) YAML values file
data "template_file" "chartmuseum" {
  template = "${file("${format("%s/%s", path.module, var.chartmuseum["values_file"])}")}"

  vars {
    username    = "${var.chartmuseum["username"]}"
    password    = "${var.chartmuseum["password"]}"
    domain_name = "${var.chartmuseum["domain_name"]}"
  }
}

# ------------------------------------------------------------------------------
# Docker Registry resources
# ------------------------------------------------------------------------------

resource "helm_release" "docker_registry" {
  depends_on = [
    "kubernetes_secret.registry_auth",
    "helm_release.chartmuseum",
  ]

  count = "${var.docker_registry["enabled"]}"

  name       = "${var.docker_registry["release_name"]}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "docker-registry"
  values     = "${data.template_file.docker_registry.rendered}"
}

# Parsed (interpolated) YAML values file
data "template_file" "docker_registry" {
  template = "${file("${format("%s/%s", path.module, var.docker_registry["values_file"])}")}"

  vars {
    domain_name = "${var.docker_registry["domain_name"]}"
  }
}

resource "kubernetes_secret" "registry_auth" {
  metadata {
    name = "docker-registry-auth"
  }

  data {
    username = "${var.docker_registry["username"]}"
    password = "${var.docker_registry["password"]}"
  }

  type = "kubernetes.io/basic-auth"
}
