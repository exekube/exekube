# Exekube

[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/ilyasotkov/exekube/) [![CircleCI](https://circleci.com/gh/ilyasotkov/exekube/tree/develop.svg?style=svg)](https://circleci.com/gh/ilyasotkov/exekube/tree/develop)

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm.

---

- **[Exekube Docs](https://ilyasotkov.github.io/exekube/)**

---

- [Terraform Docs](https://www.terraform.io/docs/index.html)
- [Kubernetes Docs](https://kubernetes.io/docs/home/?path=users&persona=app-developer&level=foundational)
- [Helm Docs](https://docs.helm.sh/)

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
