# ------------------------------------------------------------------------------
# Shared inputs and locals
# ------------------------------------------------------------------------------

variable "cloudflare_dns_zones" {
  default = []
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
    domain_name = "charts"
    domain_zone = ""
    username = ""
    password = ""
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
