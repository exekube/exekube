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
2. Created a service account named "kube-admin" in Google Cloud Console GUI, granted it Kubernetes admin role (permissions), downloaded `.json` credentials to repo root directory and renamed the file to `credentials.json`
3. `gcloud auth activate-service-account --key-file /run/secrets/credentials.json`
4. `terraform init live/gke-devel`

## Features and tasks

- [x] Create GCP account, enable billing
- [x] Get credentials for GCP
- [x] Download Google Cloud SDK
- [x] Authenticate to GCP (to create a cluster)
- [ ] Create GCP Folder structure
- [ ] Create GCP Projects
- [ ] Create GCP Organization, Folder, Project policies
- [ ] Create GCP IAM Service Accounts, Roles, and Bindings
- [x] Create GKE cluster
- [ ] (RBAC) Add cluster namespaces (virtual clusters)
- [ ] (RBAC) Add cluster roles and role bindings
- [ ] (RBAC) Add cluster network policies
- [x] Get credentials (token) for kubectl
- [ ] Install Tiller on cluster (`helm init`)
- [ ] Install cluster ingress controller (cloud load balancer)
- [ ] Install TLS certificates controller (kube-lego)
- [ ] Install monitoring tools (Prometheus, Grafana)
- [ ] Install continuous integration tools (Gitlab / Gogs, Jenkins / Drone)
- [ ] Install "hello-world" user apps
