# Exekube

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm.

## Motivation

Using many command line tools to manage cloud resources (e.g. `gcloud`, `aws`, `kops`) and Kubernetes resources (e.g. `kubectl`, `helm`) is tedious and error-prone.

Terraform already provides a declarative interface for a large number of cloud providers, so why not use Terraform to manage both cloud resources and containers through a single, fully automated interface?

## Features

- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-command-to-deploy experience
- Modular design and declarative model of management
- Freedom to choose a cloud provider to host Kubernetes
- Continuous integration (CI) facilities out of the box

## Documentation

- [Documentation website](https://ilyasotkov.github.io/exekube/)
