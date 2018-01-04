# ------------------------------------------------------------------------------
# CloudFlare vars
# ------------------------------------------------------------------------------

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain_zone" {}

# ------------------------------------------------------------------------------
# Helm vars
# ------------------------------------------------------------------------------

variable "kube_lego_release_values" {}
variable "ingress_controller_release_values" {}
