# ------------------------------------------------------------------------------
# Shared input variables (credentials)
# ------------------------------------------------------------------------------

# TBD

# ------------------------------------------------------------------------------
# Incubator release input variables
# ------------------------------------------------------------------------------

variable "istio" {
  type = "map"

  default = {
    enabled      = false
    values_file  = "values/istio.yaml"
    release_name = "istio"
  }
}

variable "drupal" {
  type = "map"

  default = {
    enabled      = false
    domain_name  = ""
    values_file  = "values/drupal.yaml"
    release_name = "drupal-app"
  }
}
