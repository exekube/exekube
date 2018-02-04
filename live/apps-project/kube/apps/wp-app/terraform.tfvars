# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "${get_env("XK_LIVE_DIR", "")}/../../modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-gke",
      "../../core/ingress-controller",
      "../../core/kube-lego",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
