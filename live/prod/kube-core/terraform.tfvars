# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//kube-core"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../gke-cluster"]
  }
}

# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

cloudflare_email = "ilya@sotkov.com"
cloudflare_domain_zone = "swarm.pw"
# cloudflare_token = <exposed as TF_VAR_cloudflare_token>

helm_values_ingress_controller = "/exekube/live/prod/kube-core/values/ingress-controller.yaml"
helm_values_kube_lego = "/exekube/live/prod/kube-core/values/kube-lego.yaml"

# helm_private_repo_url = "https://my-private-chart-repo.storage.googleapis.com"
