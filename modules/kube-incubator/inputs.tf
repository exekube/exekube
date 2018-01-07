# ------------------------------------------------------------------------------
# Istio framework: ingress-controller + monitoring
# ------------------------------------------------------------------------------

variable "istio" {
  type = "map"

  default = {
    enabled      = false
    values_file  = "values/istio.yaml"
    release_name = "istio"
  }
}

# ------------------------------------------------------------------------------
# A sample Drupal app
# ------------------------------------------------------------------------------

variable "drupal" {
  type = "map"

  default = {
    enabled      = false
    domain_name  = ""
    values_file  = "values/drupal.yaml"
    release_name = "drupal-app"
  }
}

# ------------------------------------------------------------------------------
# A sample Wordpress app
# ------------------------------------------------------------------------------

variable "wordpress" {
  type = "map"

  default = {
    enabled      = false
    domain_name  = ""
    values_file  = "values/wordpress.yaml"
    release_name = "wordpress-app"
  }
}
