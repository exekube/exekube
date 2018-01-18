# Live modules

Each directory in this `live` directory contains configuration for a 100% isolated environment.

## Environment (Project) directory structure

In `prod/infra` is a collection of live modules that can create create and manage **cloud provider resources**.

In `prod/kube` is a collection of live modules that can create and manage **Kubernetes and Helm resources**.

## Live module directory structure

Each **live module**, for example [`live/prod/kube/apps/rails-app/`](/), contains at least 2 files:

```
terraform.tfvars
inputs.tfvars
```

`terraform.tfvars` defines which Terraform module to import, declares which modules it depends on, and also allows you tweak some configuration in case you need it.

`inputs.tfvars` allows you to configure the "live" version of a generic module you imported in `terraform.tfvars`.

A live module directory can also contain other files related to it, for example the `secrets` directory or `values.yaml` for a Helm release.
