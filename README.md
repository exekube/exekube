# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is an "Infrastructure as Code" modular framework for managing the whole lifecycle of Kubernetes-based projects. Exekube is built with Terraform, Terragrunt, and Helm as its developer interfaces.

---

Quick Links:
- [**Example project (internal-ops-project)**](https://github.com/exekube/internal-ops-project)
- [**Documentation website**](https://exekube.github.io/exekube/)

---

## Motivation

Using many command line tools and GUIs to manage cloud resources (`gcloud`, `aws`, `kops`) and Kubernetes resources (`kubectl`, `helm`) is tedious and error-prone.

Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace all of the said command line tools.

Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing everything related to Kubernetes **as declarative code** in a fully automated, git-based workflow.

## Features

The framework offers you:

- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-command-to-deploy experience
- Modular design and declarative model of management
- Freedom to choose a cloud provider to host Kubernetes
- Continuous integration (CI) facilities out of the box

## Roadmap

### 0.1 — current version

- [x] Documented setup and framework usage
- [x] Every GCP project is set up manually via `gcloud` CLI
- [x] Support for Google Cloud and GKE via the `gke-cluster` Terraform module
- [x] Support for generic Helm releases via the `helm-release` module

### 0.2 — upcoming release

- [ ] Initial setup is only concerned with making Terraform functional
- [ ] A more comprehensive `gcp-kubernetes` module to replace `gke-cluster`
- [ ] Secrets are stored, rotated, and distributed in a secure way

### 1.0 — production-ready release

- [ ] Helm / Tiller are set up securely
- [ ] Add auditing and monitoring
- [ ] IAM and RBAC follow the principle of least-privilege
