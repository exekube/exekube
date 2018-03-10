# Exekube documentation

Exekube is an "Infrastructure as Code" modular framework for managing the whole lifecycle of Kubernetes-based projects. Exekube is built with Terraform, Terragrunt, and Helm as its developer interfaces.

!!! note
    Documentation is for Exekube version **0.1.0**.

    Check all Exekube releases: <https://github.com/exekube/exekube/releases>

## Introduction

- [What is Exekube?](/introduction/what-is-exekube)
- [How does Exekube compare to other software?](/introduction/exekube-vs-other)

## Setup and Installation

- [Create an Exekube project on Google Cloud Platform](/setup/gcp-gke)
- [Create an Exekube project on Amazon Web Services](/setup/aws-eks)

## Usage

- [Guide to project directory structure and framework usage](/usage/directory-structure)
- [Tutorial: deploy an application on Kubernetes with Exekube](/usage/deploy-app)

## Reference

- [gke-cluster module](/reference/gke-cluster)
- [helm-release module](/reference/helm-release)

## Miscellaneous

- [Compare using Helm CLI and terraform-provider-helm](/misc/helm-cli-vs-terraform-provider-helm)
- [How to configure a Helm release](/misc/configure-helm-release)
- [Use HashiCorp Vault to manage secrets](/misc/vault-integration)
- [Read the project's feature tracker](/misc/feature-tracker)
- [Managing secrets in Exekube](/misc/secrets)
