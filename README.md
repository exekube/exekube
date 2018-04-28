# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is a framework (platform) for managing the whole lifecycle of Kubernetes-based projects as declarative code. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools, [Terraform](https://terraform.io) and [Helm](https://helm.sh).

## Online documentation

You can find the latest Exekube documentation at <https://docs.exekube.com>.

## Repositories on GitHub

The Exekube project is divided across a few GitHub repositories:

- [exekube/exekube](/). This is the main repository that you are currently looking at. Its divided into the following subdirectories:

    - [modules](/). Exekube's Terraform module library (third-party [Module Registry](/))
    - [cli](/). Exekube's CLI (written in Go) for commands like `xk up`, `xk down`, etc.
    - [dockerfiles](/). Exekube's Dockerfiles (`exekube/exekube:<version>-<tag>`)
    - [docs](/) Markdown documentation source for https://docs.exekube.com

- [exekube/charts](/). This Git repository hosts Exekube's Helm chart repository you can add with `helm repo add exekube https://exekube.github.io/charts`

### Example projects

- [exekube/base-project](https://github.com/exekube/base-project). A minimal Exekube project on GKE with a tutorial, simple to set up
- [exekube/demo-apps-project](https://github.com/exekube/demo-grpc-project). Deploy a web apps onto GKE
- [exekube/demo-grpc-project](https://github.com/exekube/demo-grpc-project). Deploy security-hardened gRPC server app and its REST client app onto GKE
- [exekube/demo-ci-project](https://github.com/exekube/demo-ci-project). Deploy private CI tools onto GKE
- [exekube/demo-istio-project](https://github.com/exekube/demo-istio-project). Get started with the Istio mesh framework on GKE

## Getting started

Go to the *Exekube Getting Started Tutorial* at https://docs.exekube.com/in-practice/getting-started to create your first Exekube project.

## Motivation

- Using many command line tools and GUIs to manage cloud resources (`gcloud`, `aws`, `kops`) and Kubernetes resources (`kubectl`, `helm`) is tedious and error-prone
- Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace or automate the use of all of the said command line tools
- Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing everything related to Kubernetes as declarative code in an *automated, Git-based workflow* following the "Infrastructure as Code" philosophy

## Features

The framework allows you to:

- Not worry about managing dependencies like `gcloud`, `terraform`, `kubectl`, `helm`, etc. since they're all packaged into a Docker image
- Control your cloud infrastructure as declarative code via Terraform
- Control your container orchestration as decalrative code via Terraform and Helm
- Create [production-grade clusters](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) and deploy all Kubernetes resources *via one command*
- Destroy all cloud and Kubernetes resources *via one command* (to avoid wasting money in non-production environments)
- Freely choose a cloud provider to host Kubernetes (only Google Cloud Platform with experimental Alibaba Cloud support as of 0.3)

## Terraform module library (registry)

| Terraform module | Platform | Purpose |
| --- | --- | --- |
| helm-initializer | Any (Kubernetes) | Deploy Tiller into any namespace following [security best practices](https://github.com/kubernetes/helm/blob/master/docs/securing_installation.md) |
| helm-release | Any (Kubernetes) | Securely install a Helm chart (create a release) |
| helm-template-release | Any (Kubernetes) | Install a Helm chart without Tiller (`helm template ...` and `kubectl apply -f -`) |
| gke-network | Google Cloud (GKE) | Set up networking, firewall rules, DNS for an enviroment |
| gke-cluster | Google Cloud (GKE) | Create a [production-grade](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) Kubernetes cluster using Google Kubernetes Engine |
| gcp-secret-mgmt | Google Cloud (GKE) | Create encryption keys and storage buckets for securely managing secrets for an enviroment |
| ali-network | Alibaba Cloud | [Experimental] Set up networking, firewall rules, DNS for an enviroment |
| ali-cluster | Alibaba Cloud | [Experimental] Create a Kubernetes cluster using Alibaba Cloud Container Service for Kubernetes |

## Contributing

Please review the [CONTRIBUTING.md](/) file for information on how to get started contributing to the project.
