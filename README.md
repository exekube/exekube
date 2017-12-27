⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

# Exekube

*Exekube* is a declarative framework for administering Kubernetes clusters and deploying containerized software onto them.

You only need [Docker Community Edition](/) and [Docker Compose](/) on your local machine to begin using Exekube. The framework is a thin layer around several open-source DevOps tools:

- Docker Compose
- HashiCorp Terraform
- Kubernetes
- Helm for Kubernetes

The ultimate goal of this project is to enable DevOps engineers and developers to control cloud infrastructure and Kubernetes API objects using nothing more than a git repository and a Continuous Delivery pipeline.

📘 Read the companion guide: <https://github.com/ilyasotkov/learning-kubernetes/>

- [Introduction](#introduction)
	- [Principles](#principles)
	- [Technology stack](#technology-stack)
- [Set up local development environment](#set-up-local-containerized-tools)
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

### Principles

- [x] Everything on client side is dockerized and contained in repo root directory
- [x] Everything is expressed as declarative code, using Terraform and HCL (HashiCorp Language)
- [ ] Git-based workflow (no GUI or CLI) with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven (TDD) or behavior-driven (BDD) model of development

### Technology stack

#### Docker local environment

- Docker container runtime
- Docker Compose declarative client

#### Cloud provider client (only Google Cloud Platform for now)

- Imperative CLI client: `gcloud`
- Imperative GUI client: [GCP Console](/)
- ‍Declarative code client: [terraform-provider-google](/) (support for AWS and Azure in the future?)

#### Kubernetes client (Kubernetes workload, storage, networking objects)

- Imperative CLI client: `kubectl`
- Declarative code client: [terraform-kubernetes-provider](/)

#### Helm client (Repositories, Charts, Releases)

- Imperative CLI client: `helm`
- Declarative code client: [terraform-helm-provider](/)

## Setup and Usage

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
    # `xkt` is a wrapper around `terraform`
    alias xkt="docker-compose run --rm exekube terraform"

    # `xk` is used mostly for legacy imperative tools like `xk gcloud`, `xk kubectl`, `xk helm`, etc.
    alias xk="docker-compose run --rm exekube"
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
6. ⬇️ Initialize terraform:
    ```sh
    xkt init live/gcp-ethereal-argon
    ```

### Usage / workflow

#### Legacy imperative (CLI commands) Exekube toolset

Command line tools like `gcloud`, `kubectl`, and `helm` will be familiar to engineers already familiar with Google Cloud Platform and Kubernetes. These tools are battle-tested and work well, but are considered "legacy" here since this framework aims to be **declarative**. Most CLI and GUI tools will be eventually deprecated in favor of using a declarative tool -- Terraform.

- `xk gcloud`
- `xk kubectl`
- `xk helm`

```sh
# This is an example of how you can deploy an static nginx webpage and a rails application to the cluster

# Ingress controller is already implemented using Helm terraform provider plugin
xk helm install --name ingress-controller \
        -f live/helm-releases/nginx-ingress.yaml \
        modules/helm-charts/kube-lego/

xk helm install --name letsencrypt-controller \
        helm/charts/kube-lego/

xk helm install --name my-nginx-page \
        -f live/helm-releases/nginx-webpage-devel.yaml \
        modules/helm-charts/nginx-webpage/

xk helm install --name my-rails-app \
        -f live/helm-releases/rails-app-devel.yaml \
        modules/helm-charts/rails-app/
```

#### Declarative (HCL files) Exekube toolset

- `xkt` (`xk terraform`)

Declarative tools are exact equivalents of using the imperative (CLI) toolset, except everything is implemented as a Terraform provider plugin. Instead of writing CLI scripts that use `xk helm install --name <release-name> -f <values> <chart>` commands to deploy workloads to the cloud, we use `xk terraform apply`.

## Core feature tracker

Features are marked with ✔️ when they enter the alpha stage, meaning there's a declarative (except for the Preparation step) *proof-of-concept* solution implemented

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

- [x] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

### Supporting tools

- [x] Install cluster ingress controller (cloud load balancer)
- [ ] Install TLS certificates controller (kube-lego)
- [ ] Install monitoring tools (Prometheus, Grafana)
- [ ] Install continuous integration tools (Gitlab / Gogs, Jenkins / Drone)

### User apps and services

- [ ] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.

## Known issues

- [ ] If IAM API is not enabled, trying to enable it via Terraform and then creating a service account will not work since enabling an API might take longer
- [x] A LoadBalancer created via installing an ingress controller chart will not be destroyed when we run `terraform destroy`
- [ ] https://github.com/ilyasotkov/exekube/issues/4
