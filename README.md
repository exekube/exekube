# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is a framework (or platform, Platform-as-Code) for managing the whole lifecycle of Kubernetes-based projects. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools, [Terraform](https://terraform.io) and [Helm](https://helm.sh).

## Motivation

- Using many command line tools and GUIs to manage cloud resources (`gcloud`, `aws`, `kops`) and Kubernetes resources (`kubectl`, `helm`) is tedious and error-prone
- Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace or automate the use of all of the said command line tools
- Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing everything related to Kubernetes as declarative code in an *automated, Git-based workflow* following the "Infrastructure as Code" philosophy

## Examples

Check out the three demo projects that use the framework:

- [demo-apps-project](https://github.com/exekube/demo-grpc-project): Deploy a number of web apps onto Google Cloud Platform

- [demo-grpc-project](https://github.com/exekube/demo-grpc-project): Deploy a gRPC server app and its REST client app onto Google Cloud Platform

- [demo-ci-project](https://github.com/exekube/demo-ci-project): Deploy private CI tools onto Google Cloud Platform

## Features

The framework allows you to:

- Not worry about managing dependencies like `gcloud`, `terraform`, `kubectl`, `helm`, etc. since they're all packaged into a Docker image
- Control your cloud infrastructure as declarative code via Terraform
- Control your container orchestration as decalrative code via Terraform and Helm
- Create [production-grade clusters](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) and deploy all Kubernetes resources *via one command*
- Destroy all cloud and Kubernetes resources *via one command* (to avoid wasting money in non-production environments)
- Freely choose a cloud provider to host Kubernetes (only Google Cloud Platform with experimental Alibaba Cloud support as of 0.3)

## Built-in Terraform modules

| Terraform module | Platform | Purpose |
| --- | --- | --- |
| helm-initializer | Any (Kubernetes) | Deploy Tiller into any namespace following [security best practices](https://github.com/kubernetes/helm/blob/master/docs/securing_installation.md) |
| helm-release | Any (Kubernetes) | Securely install a Helm chart (create a release) |
| gke-network | Google Cloud | Set up networking, firewall rules, DNS for an enviroment |
| gke-cluster | Google Cloud | Create a [production-grade](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) Kubernetes cluster using Google Kubernetes Engine |
| gcp-secret-mgmt | Google Cloud | Create encryption keys and storage buckets for securely managing secrets for an enviroment |
| ali-network | Alibaba Cloud | [Experimental] Set up networking, firewall rules, DNS for an enviroment |
| ali-cluster | Alibaba Cloud | [Experimental] Create a Kubernetes cluster using Alibaba Cloud Container Service for Kubernetes |

## Roadmap

### 0.1 — current version

- [x] Documented setup and framework usage
- [x] Every GCP project is set up manually via `gcloud` CLI
- [x] Support for Google Cloud and GKE via the `gke-cluster` Terraform module
- [x] Support for generic Helm releases via the `helm-release` module

### 0.2 — *skipped release*

- [x] Projects (dev, stg, prod) are initialized via `project-init` bash script
- [x] Resources that don't cost anything are managed via `gcp-network` *persistent* Terraform module
- [x] Secrets are stored, rotated, and distributed in a secure way. Encryption via Cloud KMS encryption keys, storage in a Cloud Storage bucket via `gcp-secret-mgmt` *persistent* Terraform module
- [x] Helm / Tiller are set up securely with support for multiple namespaces via the `helm-ititializer` module
- [x] [@demo-apps-project](https://github.com/exekube/demo-apps-project) Add an example React app which uses ingress-gce & GCP L7 Load Balancer & CDN
- [x] [@demo-grpc-project](https://github.com/exekube/demo-grpc-project) Add an example gRPC server / client project

### 0.3 — upcoming release

- [x] Exekube CLI is now written in Go with build-in help and better error handling
- [x] Add experimental support for Alibaba Cloud
- [ ] Add a working tutorial for demo projects

### 0.4+ — future release

- [ ] Replace kube-lego with cert-manager
- [ ] Add support for Istio
- [ ] Move DNS-record management to `external-dns` Helm release, still use `gcp-project` for adding DNS zones
