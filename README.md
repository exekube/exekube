# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

Exekube is an experimental framework for administering and using Kubernetes clusters.

## Input sources and tasks to be completed

| Input source | Task |
| --- | --- |
| GCP Console (GUI) | Create cloud provider (GCP) account, enable billing |
| Docker(file) | Download cloud provider SDK (Google Cloud SDK), add binary path to `$PATH` |
| GCP Console (GUI) (.json) | Get credentials for GCP |
| Terraform | Authenticate to GCP |
| Terraform | Create cluster |
| Terraform | Add cloud roles and users (for GCP) |
| Terraform | Get credentials for cluster |
| ? | Add cluster namespaces (virtual clusters) |
| ? | Add cluster roles and role bindings |
| ? | Add network policies |
| Terraform (local-exec) | Initiaize Helm |
| Helm | Launch ingress controller (`ingress-nginx`) |
| Helm | Launch TLS certificates controller (`kube-lego`) |
| Helm | Add monitoring and alerting tools (Prometheus, Grafana) |
| Helm | Add CI tools (Jenkins, Gogs) |
| Helm | Install nginx-webpage chart |
| Helm | Install rails app chart |

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

## What I did

1. Set up a Google Account, created a project named "ethereal-argon-186217", etc.
2. Created a service account named "kube-admin" in Google Cloud Console GUI, granted it Kubernetes admin role (permissions), downloaded `.json` credentials to repo root directory and renamed the file to `kube-admin-credentials.json`

## Directory structure

```
.
├── Dockerfile
├── README.md
├── bin
│   └── terraform
├── config
│   ├── kube
│   └── gcloud
├── docker-compose.yaml
├── gke
│   ├── live
│   └── modules
└── kube-admin-credentials.json

```
