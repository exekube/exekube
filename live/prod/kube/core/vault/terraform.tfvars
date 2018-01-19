# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-gke",
      "../ingress-controller",
      "../kube-lego",
      "../vault-tls",
      "../vault-storage",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
