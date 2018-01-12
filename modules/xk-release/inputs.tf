# ------------------------------------------------------------------------------
# Cluster DNS zones and other shared variables / credentials
# ------------------------------------------------------------------------------

variable "cloudflare" {
  type = "map"

  default = {
    email = ""
    token = ""
  }
}

variable "cluster_dns_zones" {
  type = "list"

  default = []
}

# ------------------------------------------------------------------------------
# Helm release input variables
# ------------------------------------------------------------------------------

variable "release" {
  type = "map"

  default = {
    enabled        = false
    chart_repo     = ""
    chart_name     = ""
    chart_version  = ""
    release_name   = ""
    release_values = "values.yaml"

    # These are custom Exekube variables
    # that allow variable interpolation in release values.yaml
    # You don't have to use them if you prefer clean YAML in Helm release values
    domain_name = ""
  }
}
