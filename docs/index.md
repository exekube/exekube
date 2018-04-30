# Exekube Documentation

!!! success "Up to date"
    This documentation is for the latest released version:

    <span class="version-tag">0.3.0 Preliminary</span>

    Check all Exekube releases: <https://github.com/exekube/exekube/releases>

## Introduction

- [What is Exekube?](/introduction/what-is-exekube)
- [How does Exekube compare to other software?](/introduction/exekube-vs-other)

## Exekube in Practice

- [Tutorial: Getting started with Exekube](/in-practice/getting-started)
- [Guide: How Exekube projects are structured](/in-practice/directory-structure-guide)

## Example Projects

- Google Cloud Platform / GKE
    - [github.com/exekube/demo-apps-project](/)
    - [github.com/exekube/demo-grpc-project](/)
    - [github.com/exekube/demo-ci-project](/)

- Alibaba Cloud / Container Service for Kubernetes
    - [github.com/exekube/demo-alicloud-project](/) (Experimental)

## Reference

- Kubernetes and Helm
    - [helm-initializer module variables](/)
    - [helm-release module variables](/)

- Google Cloud Platform
    - [gke-network module variables](/)
    - [gke-cluster module variables](/)
    - [gcp-secret-mgmt module variables](/)

- Alibaba Cloud (Experimental)
    - [ali-network modules variables](/)
    - [ali-cluster modules variables](/)

## Miscellaneous

- Incubator notes
    - [Use HashiCorp Vault to manage secrets](/misc/vault-integration)
    - [Use Istio for pod networking](/misc/istio)

- Other notes
    - [Compare using Helm CLI and terraform-provider-helm](/misc/helm-cli-vs-terraform-provider-helm)
    - [How to configure a Helm release](/misc/configure-helm-release)
    - [Managing secrets in Exekube](/misc/secrets)
    - [Read the project's feature tracker](/misc/feature-tracker)
