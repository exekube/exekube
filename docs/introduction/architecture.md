# Exploring Exekube's Architecture

!!! tip
    Make sure to get familiar with the directory structure of Exekube [example projects](https://docs.exekube.com/introduction/what-is-exekube#examples)

## Exekube and Exekube Module Library

### The framework

Exekube is a framework, or a way of using certain tools in a certain way, following a certain directory structure. You can also call it a platform on top of Kubernetes, but you must keep in mind that it's doesn't have a GUI, instead preferring to configure things as declarative code (*Terraform* and *YAML + Go templates*) that can be commited to version control (e.g. Git).

### Exekube module library

*Exekube module library* is a library of global / external Terraform modules, similar to the [Module Registry](https://registry.terraform.io/). These modules are open-source and can be used (extended / forked / modified) in whichever way you want and can be easily consumed this way:

```tf
module "my_project_module" {
  source = "git::ssh://git@github.com/exekube//exekube/modules/helm-release?ref=0.3.0"
}
```

## Principles of the framework

1. Keep typing on the command line to a minimum.
2. Keep as much of your infrastructure / deployment configuration as declarative code following a familiar *Text editor + Git client* workflow.
3. Use open source GUIs for monitoring (getting, listing, viewing) resources, but do not use them to make any mutations (changes to real cloud resources).

## Exekube projects and environments

An Exekube project is a software project that requires us to use cloud resources (network, storage, and compute resources) in multiple environments (dev, stg, prod, qa, etc.)

| Exekube resource | Description |
| --- | --- |
| Project | A project is a collection of *Terraform modules* that will be deployed into an environment  |
| Environment | An environment a collection of live modules / Terragrunt modules / `terraform.tfvars` files in a directory structure |

## Module hierarchy for an Exekube project

<p align="center">
  <img src="/images/module-architecture.png" alt="Terrafomr module hierarchy in Exekube"/>
</p>

### External / Global modules

These are modules from an external (global) library (e.g. from the Module Registry or Exekube Module Library)

### Project-scoped modules

Project-scoped modules are **same across different deployment environments** of the same Exekube project.

### Live (environment-scoped) modules

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
