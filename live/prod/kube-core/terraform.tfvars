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

# cloudflare_domain_zone = <exposed as envrironmental variable TF_VAR_cloudflare_domain_zone>
cloudflare_email = "ilya@sotkov.com"
# cloudflare_token = <exposed as envrironmental variable TF_VAR_cloudflare_token>

ingress_controller_release_values = "/exekube/live/prod/kube-core/values/ingress-controller.yaml"
kube_lego_release_values = "/exekube/live/prod/kube-core/values/kube-lego.yaml"

# helm_private_repo_url = "https://my-private-chart-repo.storage.googleapis.com"
