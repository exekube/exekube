# Live modules

Each directory in `live` contains configuration for a 100% isolated environment. The environment is configured declaratively using Terraform code with [Terragrunt](/) as a wrapper tool that gives it full automation and less boilerplate code.

> 👋 If the deep directory structure of `live` seems intimidating or hard to understand, keep in mind that all except the leaf directories are there simply for organization. The whole `live` directory is just a collection *live modules* that will eventually be applied by Terraform.

Each environment directory, such as `prod` contains a number of **live modules** -- Terraform modules that import a *generic module* and configure it for this specfic environement.

## Environment directory structure

In `prod/infra/` is a collection of live modules that manage **cloud provider resources**. Example live module: `prod/infra/gcp-gke/`

In `prod/kube/` is a collection of live modules that manage **Kubernetes and Helm resources**. Example live module: `prod/kube/core/ingress-controller/`.

## Live module directory structure

Each **live module**, for example [`live/prod/kube/apps/ingress-controller/`](/), contains at least 2 files:

```
terraform.tfvars
inputs.tfvars
```
### `terraform.tfvars`

`terraform.tfvars` defines which generic Terraform module to import and declares which other live modules it depends on.

Commented example of `terraform.tfvars`:

```tf
# Terragrunt configuration: Terragrunt automates and improves management of Terraform modules.
terragrunt = {

  # The generic module to import.
  terraform {
    source = "/exekube/modules//helm-release"
  }

  # This live module depends on other live modules to work properly.
  dependencies {
    paths = [
      "../../../infra/gcp-gke",
      "../../core/ingress-controller",
      "../../core/kube-lego",
      "../chartmuseum",
    ]
  }

  # This module will include `terragrunt = {}` block from any `terraform.tfvars` files it can find in parent directories.
  include = {
    path = "${find_in_parent_folders()}"
  }
}
```

### `inputs.tfvars`

`inputs.tfvars` allows you to configure a generic module you imported in `terraform.tfvars`.

Commented example of `inputs.tfvars`:

```tf
release_spec = {
  enabled        = false
  release_name   = "concourse"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "concourse"
  chart_version = "1.0.0"

  domain_name = "ci.swarm.pw"
}

pre_hook = {
  command = <<-EOF
            kubectl create secret generic concourse-concourse \
            --from-file=/exekube/live/prod/kube/ci/concourse/secrets/ || true \
            && cd /exekube/charts/concourse/ \
            && bash push.sh \
            && helm repo update
            EOF
}
```

A live module directory can also contain other files related to it, for example a `secrets` directory or `values.yaml` for a Helm release.
