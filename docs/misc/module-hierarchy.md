# Exekube Terraform module hierarchy / architecture

<p align="center">
  <img src="/module-architecture.png" alt="Terrafomr module hierarchy in Exekube"/>
</p>

## External / Global modules

These are modules from an external (global) library (e.g. from the Module Registry or Exekube Module Library)

## Project-scoped modules

Project-scoped modules are **same across different deployment environments** of the same Exekube project.

## Live (environment-scoped) modules

Live modules are applicable / executable modules, the modules that will be located in the `live` directory and applied by Terraform. Exekube uses Terragrunt as a wrapper around Terraform to to reduce boilerplate code for live modules and manage multiple live modules at once.

Live modules are instances of generic modules configured for a specific deployment environment.

Project-scoped modules are imported by *live modules* (in `terraform.tfvars` files) using Terragrunt:

```tf
terragrunt = {
  terraform {
    # Import a generic module from the local filesystem
    source = "/exekube-modules//gke-cluster"
  }
  # ...
}
```
or like that:
```tf
terragrunt = {
  terraform {
    # Import a generic module from a remote git repo
    source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  }
  # ...
}
```
Live modules are always *different across different environments*.

If you run `xk up`, you are applying *the default directory with live modules*, so it is equivalent of running `xk up $TF_VAR_default_dir`. Under the cover, `xk up` calls `terragrunt apply-all`.

You can also apply an individual live module by running `xk up <live-module-path>` or groups of live modules by running `xk up <directory-structure-of-live-modules>`.
