# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

**Feature request**: I want a Rails-like experience **but for deploying generic workloads and storage resources onto Kubernetes clusters**.

Exekube is an experimental declarative framework for administering and using Kubernetes clusters.

Read the companion guide about how to learn declarative Kubernetes with Exekube: <https://github.com/ilyasotkov/learning-kubernetes/>

### Principles

- [x] Everything on client side is dockerized and contained in repo root directory
- [x] Everything is expressed as code, using Terraform and HCL (HashiCorp Language)
- [ ] Git-based workflow (no GUI or CLI) with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven

### Technology stack

- Docker and Docker Compose on the client side
- Terraform and HCL (HashiCorp Language)
- Google Cloud SDK (support for AWS and Azure in the future?)
- Kubernetes
- Helm

### Requirements

You only need Docker and Docker Compose installed on your local machine. I use [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) (Edge).

## Imperative steps for set up

0. Create `xk` alias in shell session:
    ```bash
    alias xk="docker-compose run --rm exekube"
    ```
1. Set up a Google Account, create a project named "ethereal-argon-186217", enable billing.
2. Create a service account in Google Cloud Console GUI, give it project owner permissions, download `.json` credentials ("key") to repo root directory and rename the file to `credentials.json`
3. Use `.json` credentials to activate service account:
    ```sh
    xk gcloud auth activate-service-account --key-file credentials.json
    ```
4. Create a Google Cloud Storage bucket for Terraform remote state:
    ```sh
    xk gsutil mb -p ethereal-argon-186217 gs://ethereal-argon-terraform-state
    ```
5. Enable versioning for the bucket:
    ```sh
    xk gsutil versioning set on gs://ethereal-argon-terraform-state
    ```
6. Initialize terraform:
    ```sh
    xk terraform init live/gcp-ethereal-argon
    ```

## Features / tasks

### Preparation

- [x] Create GCP account, enable billing
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
