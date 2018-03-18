# ------------------------------------------------------------------------------
# Pre-hook and post-hook, to be run before creation and after release creation
# ------------------------------------------------------------------------------

variable "xk_live_dir" {}

variable "pre_hook" {
  type = "map"

  default = {
    command = "echo hello from pre_hook"
  }
}

variable "post_hook" {
  type = "map"

  default = {
    command = "echo hello from post_hook"
  }
}

# ------------------------------------------------------------------------------
# Helm release input variables
# ------------------------------------------------------------------------------

variable "release_spec" {
  type = "map"

  default = {
    enabled        = false
    chart_repo     = ""
    namespace      = "default"
    chart_name     = ""
    chart_version  = ""
    release_name   = ""
    release_values = "values.yaml"

    domain_name = ""
  }
}

# ------------------------------------------------------------------------------
# Kubernetes secret inputs
# ------------------------------------------------------------------------------

variable "ingress_basic_auth" {
  type = "map"

  default = {
    username    = ""
    password    = ""
    secret_name = ""
  }
}
