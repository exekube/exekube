# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-project",
      "../ingress-controller",
      "../kube-lego",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
