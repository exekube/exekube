# ------------------------------------------------------------------------------
# Run a pre_hook via the null_resource provisioner
# ------------------------------------------------------------------------------

variable "pre_hook" {
  type = "map"

  default = {
    command = "echo hello from pre_hook"
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
    post_hook      = "echo hello from post_hook"

    domain_name = ""
  }
}

# ------------------------------------------------------------------------------
# Point DNS zones to our cloud load balancer IP address
# ------------------------------------------------------------------------------

variable "cluster_dns_zones" {
  type = "list"

  default = []
}

# ------------------------------------------------------------------------------
# Kubernetes secret inputs
# ------------------------------------------------------------------------------

variable "basic_auth_secret" {
  type = "map"

  default = {
    file = ""
  }
}

# ------------------------------------------------------------------------------
# Credentials for use as client, can be filled by local environmental variables
# ------------------------------------------------------------------------------

variable "cloudflare_auth" {
  type = "map"

  default = {
    email = ""
    token = ""
  }
}

variable "registry_auth" {
  type = "map"

  default = {
    username = ""
    password = ""
  }
}

variable "chartrepo_auth" {
  type = "map"

  default = {
    username = ""
    password = ""
  }
}
