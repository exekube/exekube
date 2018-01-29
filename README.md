# Exekube

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm.

## Motivation

Using many command line tools (or GUIs) to manage cloud resources (e.g. `gcloud`, `aws`, `kops`) and Kubernetes resources (e.g. `kubectl`, `helm`) is tedious and error-prone.

Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace all of the said command line tools and give us a single "Everything as Code" fully automated workflow.

Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing Kubernetes as declarative code.

## Features

The framework offers you:

- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-command-to-deploy experience
- Modular design and declarative model of management
- Freedom to choose a cloud provider to host Kubernetes
- Continuous integration (CI) facilities out of the box

## Documentation

- [Documentation website](https://ilyasotkov.github.io/exekube/)
