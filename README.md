# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

- [Introduction](#introduction)
	- [Principles](#principles)
	- [Technology stack](#technology-stack)
- [Set up local containerized tools](#set-up-local-containerized-tools)
	- [Requirements starting from zero](#requirements-starting-from-zero)
	- [Local setup step-by-step](#local-setup-step-by-step)
- [Core feature tracker](#core-feature-tracker)
	- [Preparation](#preparation)
	- [Cloud provider config](#cloud-provider-config)
	- [Cluster creation](#cluster-creation)
	- [Cluster access control](#cluster-access-control)
	- [Supporting tools](#supporting-tools)
	- [User apps and services](#user-apps-and-services)
- [Known issues](#known-issues)

## Introduction

**Core motivation for the project**: I want a Rails-like experience but for deploying generic workloads and storage resources onto Kubernetes clusters.

Exekube is an experimental declarative framework for administering and using Kubernetes clusters.

Read the companion guide about declarative Kubernetes with Exekube: <https://github.com/ilyasotkov/learning-kubernetes/>

### Principles

- [x] Everything on client side is dockerized and contained in repo root directory
- [x] Everything is expressed as declarative code, using Terraform and HCL (HashiCorp Language)
- [ ] Git-based workflow (no GUI or CLI) with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven (TDD) or behavior-driven (BDD) model of development

### Technology stack

#### **Docker** local environment

- Docker container runtime
- Docker Compose declarative client

#### Codebase

- HCL (HashiCorp Language) declarative configuration code using Terraform (`*.tf` files)

#### Google Cloud Platform toolkit

- Imperative CLI client: `gcloud`
- Imperative GUI client: [GCP Console](/)
- Declarative code client: [terraform-provider-google](/) (support for AWS and Azure in the future?)

#### Kubernetes

- Imperative CLI client: `kubectl`
- Declarative code client: [terraform-kubernetes-provider](/)

#### Helm

- Imperative CLI client: `helm`
- Declarative code client: [terraform-helm-provider](/)

## Set up local containerized tools

### Requirements starting from zero

Everything on your workstation runs in a container using Docker Compose. [Docker for Mac](/), [Docker for Windows](/) or [`docker` and `docker-compose` for Linux](/) is the only initial requirement.

### Local setup step-by-step

0. Create `xk` alias in shell session ⬇️
    ```bash
    alias xk="docker-compose run --rm exekube"
    ```
1. [Set up a Google Account for CGP (Google Cloud Platform)](https://console.cloud.google.com/), create a project named "ethereal-argon-186217", enable billing.
2. [Create a service account](/) in GCP Console GUI, give it project owner permissions.
3. [Download `.json` credentials](/) ("key") to repo root directory and rename the file to `credentials.json`.
4. Use `.json` credentials to activate service account ⬇️
    ```sh
    xk gcloud auth activate-service-account --key-file credentials.json
    ```
5. Create a Google Cloud Storage bucket (with versioning) for Terraform remote state ⬇️
    ```sh
    xk gsutil mb -p ethereal-argon-186217 gs://ethereal-argon-terraform-state \
        && xk gsutil versioning set on gs://ethereal-argon-terraform-state
    ```
6. Initialize terraform ⬇️
    ```sh
    xk terraform init live/gcp-ethereal-argon
    ```

## Core feature tracker

### Preparation

- [x] Create GCP account, enable billing in GCP Console (web GUI)
- [x] Get credentials for GCP (`credentials.json`)
- [x] Authenticate to GCP using `credentials.json` (for `gcloud` and `terraform` use)
- [x] Enable terraform remote state in a Cloud Storage bucket

### Cloud provider config

- [ ] Create GCP Folders and Projects and associated policies
- [x] Create GCP IAM Service Accounts and IAM Policies for the Project

### Cluster creation

- [x] Create the GKE cluster
- [x] Get cluster credentials (`/root/.kube/config` file)
- [x] Initialize Helm

### Cluster access control

- [ ] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

### Supporting tools

- [ ] Install cluster ingress controller (cloud load balancer)
- [ ] Install TLS certificates controller (kube-lego)
- [ ] Install monitoring tools (Prometheus, Grafana)
- [ ] Install continuous integration tools (Gitlab / Gogs, Jenkins / Drone)

### User apps and services

- [ ] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.

## Known issues

- [ ] If IAM API is not enabled, trying to enable it via Terraform and then creating a service account will not work since enabling an API might take longer
- [ ] A LoadBalancer created via installing an ingress controller chart will not be destroyed when we run `terraform destroy`
