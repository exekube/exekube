# Live modules

Each directory in `live` contains configuration for a 100% isolated environment. The environment is configured declaratively using Terraform code with [Terragrunt](/) as a wrapper tool that gives it full automation and less boilerplate code.

Each environment directory, such as `prod` contains a number of **live modules** -- Terraform modules that import a *generic module* and configure it for this specfic environement.

## Environment directory structure

In `prod/infra` is a collection of live modules that can create create and manage **cloud provider resources**.

In `prod/kube` is a collection of live modules that can create and manage **Kubernetes and Helm resources**.

## Live module directory structure

Each **live module**, for example [`live/prod/kube/apps/rails-app/`](/), contains at least 2 files:

```
terraform.tfvars
inputs.tfvars
```
### `terraform.tfvars`

`terraform.tfvars` defines which generic Terraform module to import, declares which other live modules it depends on, and also allows you tweak some configuration in case you need it.

Commented example:

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
      "../../../infra/gcp-project",
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

`inputs.tfvars` allows you to configure the "live" version of a generic module you imported in `terraform.tfvars`.

Commented example:

```tf
# Files in ./secrets directory must NOT have a trailing newline!

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

A live module directory can also contain other files related to it, for example the `secrets` directory or `values.yaml` for a Helm release.
