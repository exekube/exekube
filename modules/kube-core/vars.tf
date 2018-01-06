# ------------------------------------------------------------------------------
# CloudFlare vars
# ------------------------------------------------------------------------------

variable "cloudflare" {
  type = "map"

  default = {
    email = ""
    token = ""
  }
}

variable "cloudflare_dns_zones" {
  type = "list"
  default = []
}

# ------------------------------------------------------------------------------
# Helm vars
# ------------------------------------------------------------------------------

variable "kube_lego" {
  type = "map"

  default = {
    enabled = false
    values_file = "values/kube-lego.yaml"
  }
}

variable "ingress_controller" {
  type = "map"

  default = {
    enabled = false
    values_file = "values/ingress-controller.yaml"
  }
}
