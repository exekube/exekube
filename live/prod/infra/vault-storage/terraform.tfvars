# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//vault-storage"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
