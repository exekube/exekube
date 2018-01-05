terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "helm" {}

provider "kubernetes" {}

# ------------------------------------------------------------------------------
# Install CI Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "jenkins" {
  count      = "${var.jenkins_enabled}"
  name       = "${var.jenkins_release_name}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${data.template_file.jenkins.rendered}"
}

data "template_file" "jenkins" {
  template = "${file("${var.jenkins_release_values}")}"

  vars {
    jenkins_domain_name = "${var.jenkins_domain_name}"
  }
}

# ------------------------------------------------------------------------------

resource "helm_release" "chartmuseum" {
  depends_on = ["helm_release.jenkins"]
  count      = "${var.chartmuseum_enabled}"

  name       = "${var.chartmuseum_release_name}"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "chartmuseum"
  values     = "${data.template_file.chartmuseum.rendered}"

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

resource "helm_release" "docker_registry" {
  depends_on = [ "kubernetes_secret.registry_auth" ]

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
