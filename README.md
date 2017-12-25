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
3. `gcloud auth activate-service-account --key-file /run/secrets/credentials.json`
4. `terraform init live/gke-devel`

## Features and tasks

- [x] Create GCP account, enable billing
- [x] Get credentials for GCP
- [x] Download Google Cloud SDK
- [x] Authenticate to GCP (for `gcloud` and `terraform` use)
- [ ] Create GCP Folders and Projects and associated policies
- [x] [Access control] Create GCP IAM Service Accounts and IAM Policies for the Project
- [x] Create the GKE cluster
- [x] Get cluster credentials (`root/.kube/config` file)
- [x] [System releases] Install Tiller on cluster (`helm init`)
- [ ] [Access control] Add cluster namespaces (virtual clusters)
- [ ] [Access control] Add cluster roles and role bindings
- [ ] [Access control] Add cluster network policies
- [ ] [System releases] Install cluster ingress controller (cloud load balancer)
- [ ] [System releases] Install TLS certificates controller (kube-lego)
- [ ] [System releases] Install monitoring tools (Prometheus, Grafana)
- [ ] [System releases] Install continuous integration tools (Gitlab / Gogs, Jenkins / Drone)
- [ ] [User releases] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.
