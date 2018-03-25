# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is a high-level framework for managing the whole lifecycle of Kubernetes-based projects. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools: Terraform and Helm.

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

- Not worry about managing dependencies like `gcloud`, `terraform`, `kubectl`, `helm`, etc. since they're all packaged in a Docker image
- Control your cloud infrastructure as declarative code via Terraform
- Control your container orchestration as decalrative code via Terraform and Helm
- :warning: TBD! Create [production-grade](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod) clusters and deploy all Kubernetes resources via one command
- Destroy all cloud and Kubernetes resources via one command (to avoid wasting money in non-production environments)
- Freely choose a cloud provider to host Kubernetes (only Google Cloud Platform as of 0.2)

## Built-in Terraform modules

| Terraform module | Purpose |
| --- | --- |
| gcp-project | Enable project APIs, set up networking, firewall rules, DNS |
| gcp-kms-secret-mgmt | Create encryption keys and storage buckets for securely managing project secrets |
| gke-cluster | Create a production-grade Kubernetes cluster |
| helm-tiller | Deploy Tiller into any namespace following [security best practices](https://github.com/kubernetes/helm/blob/master/docs/securing_installation.md) |
| helm-release | Securely install a Helm chart (create a release) |

## Roadmap

### 0.1 — current version

- [x] Documented setup and framework usage
- [x] Every GCP project is set up manually via `gcloud` CLI
- [x] Support for Google Cloud and GKE via the `gke-cluster` Terraform module
- [x] Support for generic Helm releases via the `helm-release` module

### 0.2 — *upcoming release*

- [x] Cloud projects are created via `project-init` bash script
- [x] Resources that don't cost anything are managed via `gcp-project` *persistent* Terraform module
- [x] Secrets are stored, rotated, and distributed in a secure way. Encryption via Cloud KMS encryption keys, storage in a Cloud Storage bucket via `gcp-kms-secret-mgmt` *persistent* Terraform module
- [x] Helm / Tiller are set up securely with support for multiple namespaces via the `helm-tiller` module
- [x] Add an example React app which uses ingress-gce & GCP L7 Load Balancer & CDN [@internal-ops-project](https://github.com/exekube/internal-ops-project)
