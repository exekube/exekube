# ------------------------------------------------------------------------------
# CloudFlare vars
# ------------------------------------------------------------------------------

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain_zone" {}


# ------------------------------------------------------------------------------
# Helm vars
# ------------------------------------------------------------------------------

variable "helm_values_kube_lego" {}
variable "helm_values_ingress_controller" {}
