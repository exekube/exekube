terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "kubernetes" {}

# ------------------------------------------------------------------------------
# Jenkins release
# ------------------------------------------------------------------------------

resource "helm_release" "jenkins" {
  count      = "${local.jenkins["enabled"]}"
  name       = "${var.jenkins["release_name"]}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${data.template_file.jenkins.rendered}"
}

# Parsed (interpolated) YAML values file
data "template_file" "jenkins" {
  template = "${file("${var.jenkins["release_values"]}")}"

  vars {
    domain_name = "${format("%s.%s", var.jenkins["domain_name"], local.jenkins["domain_zone"] )}"
  }
}

# ------------------------------------------------------------------------------
# ChartMuseum resources
# ------------------------------------------------------------------------------

resource "helm_release" "chartmuseum" {
  depends_on = ["helm_release.jenkins"]
  count      = "${var.chartmuseum_enabled}"

  name       = "${var.chartmuseum_release_name}"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "chartmuseum"
  values     = "${data.template_file.chartmuseum.rendered}"

  set {
    name  = ""
    value = ""
  }

  provisioner "local-exec" {
    command = "sleep 10 && cd /exekube/charts/rails-app && bash push.sh && helm repo update"
  }
}

data "template_file" "chartmuseum" {
  template = "${file("${var.chartmuseum_release_values}")}"

  vars {
    chartmuseum_username    = "${var.chartmuseum_username}"
    chartmuseum_password    = "${var.chartmuseum_password}"
    chartmuseum_domain_name = "${var.chartmuseum_domain_name}"
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

  count      = "${var.docker_registry_enabled}"
  name       = "${var.docker_registry_release_name}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "docker-registry"
  values     = "${data.template_file.docker_registry_values.rendered}"
}

data "template_file" "docker_registry_values" {
  template = "${file("${var.docker_registry_release_values}")}"

  vars {
    docker_registry_domain_name = "${var.docker_registry_domain_name}"
  }
}

resource "kubernetes_secret" "registry_auth" {
  metadata {
    name = "docker-registry-auth"
  }

  data {
    username = "${var.docker_registry_username}"
    password = "${var.docker_registry_password}"
  }

  type = "kubernetes.io/basic-auth"
}
