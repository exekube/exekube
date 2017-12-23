# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

Exekube is an experimental framework for administering and using Kubernetes clusters.

## Principles

- [x] Everything is expressed as code, using Terraform / HCL
- [x] Git-based workflow (no GUI or large CLI)
- [x] Client side is fully containerized
- [x] No vendor lock-in, choose any cloud provider you want
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
