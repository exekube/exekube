# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//vendor/private-tls-cert"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
