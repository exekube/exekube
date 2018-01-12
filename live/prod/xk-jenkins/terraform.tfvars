# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//xk-release"
  }

  dependencies {
    paths = ["../gcp-project"]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
