# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//private-tls-cert"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
