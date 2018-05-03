# Exekube Documentation

!!! success "Up to date"
    This documentation is for the latest released version:

    <span class="version-tag">0.3.0</span> (3 May 2018)

    Check all Exekube releases: <https://github.com/exekube/exekube/releases>

## Introduction

- [What is Exekube?](/introduction/what-is-exekube)
- [How does Exekube compare to other software?](/introduction/exekube-vs-other)
- [How does Exekube work? (architecture and terminology)](/introduction/architecture)

## In Practice

- [Get started with Exekube](/in-practice/getting-started)
- [Configure production-grade networking](/in-practice/production-networking)
- [Configure production-grade storage](/in-practice/production-storage)

## Example Projects

- [exekube/base-project](https://github.com/exekube/base-project): A minimal Exekube project / starter / boilerplate
- [exekube/demo-apps-project](https://github.com/exekube/demo-apps-project): Project with generic web applications (Ruby on Rails, React)
- [exekube/demo-grpc-project](https://github.com/exekube/demo-grpc-project): Project for using `NetworkPolicy` resources to secure namespaces for a gRPC server app and its REST client app
- [exekube/demo-ci-project](https://github.com/exekube/demo-ci-project): Project for  private CI tools (Concourse, Docker Registry, ChartMuseum)
- [exekube/demo-istio-project](https://github.com/exekube/demo-istio-project): Playground for getting to know the Istio mesh framework

## Exekube Module Library Reference

- Kubernetes and Helm
    - [helm-initializer](https://github.com/exekube/exekube/tree/master/modules/helm-initializer): Module for installing Tiller (with TLS) for a namespace
    - [helm-release](https://github.com/exekube/exekube/tree/master/modules/helm-release): Module for securely installing Helm charts
    - [helm-template-release](https://github.com/exekube/exekube/tree/master/modules/helm-template-release): Module for installing Helm charts without Tiller (uses `helm template` and `kubectl apply`)

- Google Cloud Platform
    - [gke-network module](https://github.com/exekube/exekube/tree/master/modules/gke-network): Module for creating a VPC and other networking cloud resources for GKE clusters
    - [gke-cluster module](https://github.com/exekube/exekube/tree/master/modules/gke-cluster): Module for creating GKE clusters
    - [gcp-secret-mgmt module](https://github.com/exekube/exekube/tree/master/modules/gcp-secret-mgmt): Module for creating GCS buckets and KMS encryption keys for distributing project secrets

- Alibaba Cloud (Experimental)
    - [ali-network module](https://github.com/exekube/exekube/tree/master/modules/ali-network): Module for creating a VPC and other networking resources for Kubernetes clusters on Alibaba Cloud
    - [ali-cluster module](https://github.com/exekube/exekube/tree/master/modules/ali-cluster): Module for creating Kubernetes clusters on Alibaba Cloud

## Miscellaneous

- Incubator articles
    - [Terraform / Terragrunt module hierarchy in Exekube projects](/misc/module-hierarchy)
