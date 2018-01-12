# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//xk-core"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../gcp-project"]
  }
}
