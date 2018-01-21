# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//gcp-gke"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
