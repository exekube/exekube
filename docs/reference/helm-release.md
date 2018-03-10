# helm-release module reference

Module inputs and defaults:

```tf
# ------------------------------------------------------------------------------
# Pre-hook and post-hook, to be run before creation and after release creation
# ------------------------------------------------------------------------------

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

variable "xk_live_dir" {}

variable "ingress_basic_auth" {
  type = "map"

  default = {
    username    = ""
    password    = ""
    secret_name = ""
  }
}
```
