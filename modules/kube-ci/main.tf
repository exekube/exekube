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
  values     = "${file("${var.jenkins_release_values}")}"
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
    command = "cd /exekube/charts/rails-app && bash push.sh"
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
  count      = "${var.docker_registry_enabled}"
  name       = "${var.docker_registry_release_name}"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "docker-registry"
  values     = "${file("${var.docker_registry_release_values}")}"
}
