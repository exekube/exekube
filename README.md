# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

Exekube is an experimental framework for administering and using Kubernetes clusters.

## Principles

- [x] Everything is expressed as code, using Terraform / HCL
- [x] Git-based workflow (no GUI or large CLI)
- [x] Client side is fully containerized
- [ ] No vendor lock-in, choose any cloud provider you want (only GCP for now)
- [ ] Test-driven

## Technology stack

- Docker
- Google Cloud SDK
- Kubernetes
- Terraform
- Helm

## Input sources and tasks to be completed

| Input source | Task |
| --- | --- |
| GCP Console (GUI) | Create cloud provider (GCP) account, enable billing |
| Dockerfile | Download cloud provider SDK (Google Cloud SDK), add binary path to `$PATH` |
| GCP Console (GUI) | Get credentials for GCP |
| `.json` file + `GOOGLE_CLOUD_KEYFILE_JSON` reference + Terraform (.tf) | Authenticate to GCP |
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

## What I did

1. Set up a Google Account, created a project named "ethereal-argon-186217", etc.
2. Created a service account named "kube-admin" in Google Cloud Console GUI, granted it Kubernetes admin role (permissions), downloaded `.json` credentials to repo root directory and renamed the file to `kube-admin-credentials.json`
3. `gcloud auth activate-service-account --key-file kube-admin-credentials.json`
4. `terraform init live/gke-prod`
