# ------------------------------------------------------------------------------
# Shared inputs and locals
# ------------------------------------------------------------------------------

variable "cloudflare_domain_zone" {}

locals {
  domain_zone = "${var.cloudflare_domain_zone}"
}

# ------------------------------------------------------------------------------
# Jenkins inputs and locals
# ------------------------------------------------------------------------------

variable "jenkins" {
  type = "map"

  default = {
    enabled        = true
    release_name   = "jenkins"
    release_values = ""
    domain_name    = "jenkins"
    domain_zone    = ""
  }
}

# Parsed input variables for internal module use
locals {
  jenkins = {
    enabled     = "${var.jenkins["enabled"] ? 1 : 0}"
    domain_zone = "${var.jenkins["domain_zone"] == "" ? local.domain_zone : var.jenkins["domain_zone"]}"
  }
}

# ------------------------------------------------------------------------------
# ChartMuseum variables
# ------------------------------------------------------------------------------

variable "chartmuseum_enabled" {
  default = 1
}

variable "chartmuseum_release_name" {}
variable "chartmuseum_release_values" {}
variable "chartmuseum_domain_name" {}
variable "chartmuseum_username" {}
variable "chartmuseum_password" {}

# ------------------------------------------------------------------------------
# Docker Registry variables
# ------------------------------------------------------------------------------

variable "docker_registry_enabled" {
  default = 1
}

variable "docker_registry_release_name" {}
variable "docker_registry_release_values" {}
variable "docker_registry_domain_name" {}
variable "docker_registry_username" {}
variable "docker_registry_password" {}
