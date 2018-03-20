# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is a modular framework for managing the whole lifecycle of Kubernetes-based projects. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools: HashiCorp Terraform and Helm.

---

Quick Links:
- [**Example project (internal-ops-project)**](https://github.com/exekube/internal-ops-project)
- [**Documentation website**](https://exekube.github.io/exekube/)

---

## Motivation

- Using many command line tools and GUIs to manage cloud resources (`gcloud`, `aws`, `kops`) and Kubernetes resources (`kubectl`, `helm`) is tedious and error-prone
- Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace all of the said command line tools
- Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing everything related to Kubernetes as declarative code in an **automated, Git-based workflow** following the "Infrastructure as Code" philosophy

## Features

The framework allows you to:

- Not worry about managing dependencies like Google Cloud SDK, Terraform, `kubectl`, etc. since they're all packaged in a Docker image
- Control your cloud infrastructure as declarative code via Terraform
- Control your container orchestration as decalrative code via Terraform and Helm
- Create a production-grade clusters and deploy all Kubernetes resources **via one command**
- Destroy all cloud and Kubernetes resources via one command (to avoid wasting money in non-production environments)
- Freely choose a cloud provider to host Kubernetes (only Google Cloud Platform as of 0.2)

## Roadmap

### 0.1 — current version

- [x] Documented setup and framework usage
- [x] Every GCP project is set up manually via `gcloud` CLI
- [x] Support for Google Cloud and GKE via the `gke-cluster` Terraform module
- [x] Support for generic Helm releases via the `helm-release` module

### 0.2 — upcoming release

- [x] Initial setup is only concerned with making Terraform functional
- [x] Resources that don't cost anything are managed via a *persistent* Terraform module `gcp-project`
- [x] Secrets are stored, rotated, and distributed in a secure way. Encryption via Cloud KMS, storage in a Cloud Storage bucket

### 1.0 — production-ready release

- [ ] Helm / Tiller are set up securely
- [ ] Add auditing and monitoring
- [ ] IAM and RBAC follow the principle of least-privilege
