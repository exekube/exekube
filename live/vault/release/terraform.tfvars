# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../prod/infra/gcp-gke",
      "../tls",
      "../storage",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
