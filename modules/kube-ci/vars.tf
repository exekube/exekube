# ------------------------------------------------------------------------------
# Shared inputs and locals
# ------------------------------------------------------------------------------

variable "cloudflare_dns_zones" {
  type = "list"
}

locals {
  domain_zone = "${var.cloudflare_dns_zones[0]}"
  chartmuseum = {
    domain_zone = "${var.chartmuseum["domain_zone"] == "" ? local.domain_zone : var.chartmuseum["domain_zone"]}"
    full_domain_name = "${format("%s.%s", var.chartmuseum["domain_name"], local.chartmuseum["domain_zone"])}"
  }

  jenkins = {
    domain_zone = "${var.jenkins["domain_zone"] == "" ? local.domain_zone : var.jenkins["domain_zone"]}"
  }

  docker_registry = {
    domain_zone = "${var.docker_registry["domain_zone"] == "" ? local.domain_zone : var.docker_registry["domain_zone"]}"
  }
}

# ------------------------------------------------------------------------------
# Jenkins inputs and locals
# ------------------------------------------------------------------------------

variable "jenkins" {
  type = "map"

  default = {
    enabled             = false
    release_name        = "jenkins"
    values_file = "values/jenkins.yaml"
    domain_name         = "ci"
    domain_zone         = ""
  }
}

# ------------------------------------------------------------------------------
# ChartMuseum inputs and locals
# ------------------------------------------------------------------------------

variable "chartmuseum" {
  type = "map"

  default = {
    enabled             = false
    release_name        = "chartmuseum"
    values_file = "values/chartmuseum.yaml"
    domain_name         = "charts"
    domain_zone         = ""
  }
}

# ------------------------------------------------------------------------------
# Docker Registry inputs and locals
# ------------------------------------------------------------------------------

variable "docker_registry" {
  type = "map"

  default = {
    enabled             = false
    release_name        = "docker-registry"
    values_file = "values/docker-registry.yaml"
    domain_name         = "registry"
    domain_zone         = ""
  }
}
