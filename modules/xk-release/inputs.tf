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
    post_hook      = "echo hello world"

    domain_name = ""

    chartrepo_username = ""
    chartrepo_password = ""

    basic_auth        = ""
    pull_secret       = ""
    registry_username = ""
    registry_password = ""
  }
}
