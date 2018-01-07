# ------------------------------------------------------------------------------
# Shared input variables (credentials)
# ------------------------------------------------------------------------------

variable "chartmuseum" {
  type = "map"

  default = {
    username    = ""
    password    = ""
    domain_name = ""
  }
}

# ------------------------------------------------------------------------------
# Rails App input variables
# ------------------------------------------------------------------------------

variable "rails_app" {
  type = "map"

  default = {
    enabled      = false
    values_file  = "values/rails-app.yaml"
    release_name = "app"
    domain_name  = ""
  }
}
