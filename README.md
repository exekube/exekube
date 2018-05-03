# Exekube

[![CircleCI](https://circleci.com/gh/exekube/exekube.svg?style=shield)](https://circleci.com/gh/exekube/exekube) [![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat)](https://hub.docker.com/r/exekube/exekube/) [![Go Report Card](https://goreportcard.com/badge/github.com/exekube/exekube)](https://goreportcard.com/report/github.com/exekube/exekube)

Exekube is a framework (platform) for managing the whole lifecycle of Kubernetes-based projects as declarative code. It takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools, [Terraform](https://terraform.io) and [Helm](https://helm.sh).

## Online documentation

You can find the latest Exekube documentation at <https://docs.exekube.com>.

## Repositories on GitHub

The Exekube project is divided across a few GitHub repositories:

- [exekube/exekube](https://github.com/exekube/exekube). This is the main repository that you are currently looking at. Its divided into the following subdirectories:

    - [modules](https://github.com/exekube/exekube/tree/master/modules). Exekube's Terraform module library (third-party [Module Registry](/))
    - [cli](https://github.com/exekube/exekube/tree/master/cli). Exekube's CLI (written in Go) for commands like `xk up`, `xk down`, etc.
    - [dockerfiles](https://github.com/exekube/exekube/tree/master/dockerfiles). Exekube's Dockerfiles (`exekube/exekube:<version>-<tag>`)
    - [docs](https://github.com/exekube/exekube/tree/master/docs) Documentation source for https://docs.exekube.com (MkDocs / Material theme / Markdown)

- [exekube/charts](https://github.com/exekube/charts). This Git repository hosts Exekube's Helm chart repository you can add with `helm repo add exekube https://exekube.github.io/charts`

### Example projects

- [exekube/base-project](https://github.com/exekube/base-project): A minimal Exekube project on Google Cloud Platform / GKE
- [exekube/demo-apps-project](https://github.com/exekube/demo-grpc-project): Deploy web applications (Ruby on Rails, React) onto Google Cloud Platform / GKE
- [exekube/demo-ci-project](https://github.com/exekube/demo-ci-project): Deploy private CI tools (Concourse, Docker Registry, ChartMuseum) onto Google Cloud Platform / GKE
- [exekube/demo-grpc-project](https://github.com/exekube/demo-grpc-project): Deploy a hello-world gRPC server app and its REST client app onto Google Cloud Platform / GKE
- [exekube/demo-istio-project](https://github.com/exekube/demo-istio-project): Get started with the Istio mesh framework on GKE

## Getting started

Go to the *Exekube Getting Started Tutorial* at https://docs.exekube.com/in-practice/getting-started to create your first Exekube project.

## Motivations

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
| helm-initializer | Any (Kubernetes) | Module for deploying Tiller into any namespace following [security best practices](https://github.com/kubernetes/helm/blob/master/docs/securing_installation.md) |
| helm-release | Any (Kubernetes) | Module for installing Helm charts (creating a release) |
| helm-template-release | Any (Kubernetes) | Module for installing Helm charts without Tiller (uses `helm template` and `kubectl apply`) |
| gke-network | Google Cloud (GKE) | Module for creating a VPC and other networking cloud resources for GKE clusters |
| gke-cluster | Google Cloud (GKE) | Module for creating [production-grade](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) Kubernetes clusters using Google Kubernetes Engine |
| gcp-secret-mgmt | Google Cloud (GKE) | Module for creating GCS buckets and KMS encryption keys for securely distributing project secrets |
| ali-network | Alibaba Cloud | [Experimental] Module for creating a VPC and other networking resources for Kubernetes clusters on Alibaba Cloud |
| ali-cluster | Alibaba Cloud | [Experimental] Module for creating Kubernetes clusters on Alibaba Cloud |

## Contributing

Please review the [CONTRIBUTING.md](CONTRIBUTING.md) file for information on how to get started contributing to the project.
