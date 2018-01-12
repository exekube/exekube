# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//xk-release"
  }

  dependencies {
    paths = ["../gcp-project", "../xk-core", "../xk-registry", "../xk-chartmuseum"]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
