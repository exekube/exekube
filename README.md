# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

Exekube is an experimental declarative framework for administering and using Kubernetes clusters.

### Technology stack

- Docker and Docker Compose
- Terraform
- Google Cloud SDK (support for AWS and Azure in the future?)
- Kubernetes
- Helm

### Principles

- [x] Everything on client side is dockerized and contained in repo root directory
- [x] Everything is expressed as code, using Terraform and HCL (HashiCorp Language)
- [ ] Git-based workflow (no GUI or CLI) with a CI pipeline
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven

### Requirements

You only need Docker and docker-compose installed on your local machine.

## What I did

1. Set up a Google Account, created a project named "ethereal-argon-186217", etc.
2. Created a service account in Google Cloud Console GUI, gave it project owner permissions, downloaded `.json` credentials ("key") to repo root directory and renamed the file to `credentials.json`
3. `gcloud auth activate-service-account --key-file credentials.json`
4. `terraform init live/gcp-ethereal-argon`

## Features / tasks

### Preparation

- [x] Create GCP account, enable billing
- [x] Get credentials for GCP (`credentials.json`)
- [x] Authenticate to GCP (for `gcloud` and `terraform` use)
- [ ] Enable terraform remote state in a Cloud Storage bucket

### Cloud provider config

- [ ] Create GCP Folders and Projects and associated policies
- [x] Create GCP IAM Service Accounts and IAM Policies for the Project

### Cluster creation

- [x] Create the GKE cluster
- [x] Get cluster credentials (`root/.kube/config` file)
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
