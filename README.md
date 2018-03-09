# Exekube

[![Docker Automated build](https://img.shields.io/badge/hub.docker.com-automated-blue.svg?style=flat-square)](https://hub.docker.com/r/ilyasotkov/exekube/)

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm. Exekube allows you to manage both cloud provider resources and Kubernetes resources through a single declarative interface.

---

- **Go to example project: [internal-ops-project](https://github.com/exekube/internal-ops-project)**

- **[Go to documentation website](https://exekube.github.io/exekube/)**

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
