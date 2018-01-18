# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//xk-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-project",
      "../../core/ingress-controller",
      "../../core/kube-lego",
      "../chartmuseum",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
