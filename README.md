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
3. `gcloud auth activate-service-account --key-file credentials.json`
4. `terraform init live/gke-devel`

## Input sources and tasks to be completed

| Input source | Task |
| --- | --- |
| GCP Console (GUI) | Create cloud provider (GCP) account, enable billing |
| Dockerfile | Download cloud provider SDK (Google Cloud SDK), add binary path to `$PATH` |
| GCP Console (GUI) | Get credentials for GCP |
| `.json` file + Terraform (.tf) | Authenticate to GCP |
|  Terraform (.tf) | Create cluster |
|  Terraform (.tf) | Add cloud roles and users (for GCP) |
|  Terraform (.tf) | Get credentials for cluster |
| ? | Add cluster namespaces (virtual clusters) |
| ? | Add cluster roles and role bindings |
| ? | Add network policies |
|  Terraform (.tf) local-exec provisioner | Initiaize Helm |
| Helm | Launch ingress controller (`ingress-nginx`) |
| Helm | Launch TLS certificates controller (`kube-lego`) |
| Helm | Add monitoring and alerting tools (Prometheus, Grafana) |
| Helm | Add CI tools (Jenkins, Gogs) |
| Helm | Install nginx-webpage chart |
| Helm | Install rails app chart |
