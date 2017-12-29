⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

# Exekube

*Exekube* is a declarative framework for administering Kubernetes clusters and deploying containerized software onto them.

You only need [Docker CE](/) and [Docker Compose](/) on your local machine to begin using Exekube. The framework is a thin layer around several open-source DevOps tools:

- Docker Compose (for our local deveopment environment)
- Terraform by HashiCorp
- Kubernetes
- Helm

The goal of this project is to make it easy and straightforward for DevOps engineers to manage cloud resources and Kubernetes API resources using a git-based workflow and a Continuous Delivery (Continuous Integration) pipeline.

📘 Read the companion guide: <https://github.com/ilyasotkov/learning-kubernetes/>

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Exekube](#exekube)
	- [Introduction](#introduction)
		- [Design Principles](#design-principles)
	- [Setup and usage](#setup-and-usage)
		- [Requirements starting from zero](#requirements-starting-from-zero)
			- [Linux](#linux)
			- [macOS](#macos)
			- [Windows](#windows)
		- [Local setup step-by-step](#local-setup-step-by-step)
		- [Usage / workflow](#usage-workflow)
			- [Legacy imperative workflow (CLI)](#legacy-imperative-workflow-cli)
			- [Declarative workflow (HCL `*.tf` files)](#declarative-workflow-hcl-tf-files)
	- [Feature tracker](#feature-tracker)
		- [Cloud provider and local environment setup](#preparation)
		- [Cloud provider config](#cloud-provider-config)
		- [Cluster creation](#cluster-creation)
		- [Cluster access control](#cluster-access-control)
		- [Supporting tools](#supporting-tools)
		- [User apps and services](#user-apps-and-services)

<!-- /TOC -->

## Introduction

### Design Principles

- [x] Everything on client side is dockerized
- [x] Infrastructure (cloud provider) and Kubernetes API objects are expressed as declarative code, using Terraform HCL (HashiCorp Language) and Helm packages
- [ ] Git-based workflow with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want [only GCP for now]
- [ ] Test-driven (TDD) or behavior-driven (BDD) model of development

## Setup and usage

### Requirements starting from zero

Everything on your workstation runs in a container using Docker Compose.

The only requirements, depending on your local OS:

#### Linux

- [Docker](/)
- [Docker Compose](/)

#### macOS

- [Docker for Mac](/)

#### Windows

- [Docker for Windows](/)

### Local setup step-by-step

0. ⬇️ Create `xkt` and `xk` aliases for shell session (or save to ~/.bashrc):
    ```bash
    # `xk` is used mostly for legacy imperative tools like `xk gcloud`, `xk kubectl`, `xk helm`
    alias xk="docker-compose run --rm exekube"

    # `xkt` is a wrapper around `terraform` ("exekube terraform")
    alias xkt="docker-compose run --rm exekube terraform"
    ```
1. [Set up](https://console.cloud.google.com/) a Google Account for CGP (Google Cloud Platform), create a project named "ethereal-argon-186217", enable billing.
2. [Create](/) a service account in GCP Console GUI, give it project owner permissions.
3. [Download](/) `.json` credentials ("key") to repo root directory and rename the file to `credentials.json`.
4. ⬇️ Use `.json` credentials to activate service account:
    ```sh
    xk gcloud auth activate-service-account --key-file credentials.json
    ```
5. ⬇️ Create a Google Cloud Storage bucket (with versioning) for Terraform remote state:
    ```sh
    xk gsutil mb -p ethereal-argon-186217 gs://ethereal-argon-terraform-state \
        && xk gsutil versioning set on gs://ethereal-argon-terraform-state
    ```
6. ⬇️ Initialize terraform and create the cluster:
    ```sh
    export XK_WORKDIR=/exekube/live/infra/gcp-ethereal-argon
    xkt init
    xkt apply
    ```
7. ⬇️ Deploy cluster resources:
    ```sh
    export CLOUDFLARE_EMAIL=<your-cloudflare-account-email>
    export CLOUDFLARE_TOKEN=<your-secret-token>

    export XK_WORKDIR=/exekube/live/kube
    xkt init
    xkt apply
    ```

### Usage / workflow

#### Legacy imperative workflow (CLI)

⚠️ These tools are relatively mature and work well, but are considered *legacy* here since this framework aims to be [declarative](/)

Command line tools `kubectl` and `helm` are known to those who are familiar with Kubernetes. Google Cloud SDK (with `gcloud`) is used for managing infrastructure on the Google Cloud Platform.

- `xk gcloud`
- `xk kubectl`
- `xk helm`

```sh
xk helm install --name ingress-controller \
        -f live/kube/nginx-ingress.yaml \
        modules/helm-charts/kube-lego/

xk helm install --name letsencrypt-controller \
        helm/charts/kube-lego/

xk helm install --name my-nginx-page \
        -f live/kube/nginx-webpage-devel.yaml \
        modules/helm-charts/nginx-webpage/

xk helm install --name my-rails-app \
        -f live/kube/rails-app-devel.yaml \
        modules/helm-charts/rails-app/
```

#### Declarative workflow (HCL `*.tf` files)

- `xkt apply`

Declarative tools are exact equivalents of the legacy imperative (CLI) toolset, except everything is implemented as a [Terraform provider plugin](/) and expressed as declarative HCL (HashiCorp Language) code. Instead of writing CLI commands like `xk helm install --name <release-name> -f <values> <chart>` for each individual Helm release, we install all releases simultaneously by running `xkt apply`.

## Feature tracker

Features are marked with ✔️ when they enter the *alpha stage*, meaning a minimum viable solution has been implemented

### Cloud provider and local environment setup

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

- [x] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

### Supporting tools

- [x] Install cluster ingress controller (cloud load balancer)
- [x] Install TLS certificates controller (kube-lego)
- [ ] Install Continuous Delivery tools
    - [x] Continuous Delivery service (Drone / Jenkins)
    - [ ] Git service (Gitlab / Gogs)
- [ ] Monitoring and alerting tools (Prometheus / Grafana)

### User apps and services

- [ ] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.
