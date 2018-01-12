# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//gcp-project"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
