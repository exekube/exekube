# Feature tracker

Features are marked with ✔️ when they enter the *alpha stage*, meaning a minimum viable solution has been implemented

## Cloud provider and local environment setup

- [x] Create GCP account, enable billing in GCP Console (web GUI)
- [x] Get credentials for GCP (`credentials.json`)
- [x] Authenticate to GCP using `credentials.json` (for `gcloud` and `terraform` use)
- [x] Enable terraform remote state in a Cloud Storage bucket

## Cloud provider config

- [ ] Create GCP Folders and Projects and associated policies
- [ ] Create GCP IAM Service Accounts and IAM Policies for the Project

## Cluster creation

- [x] Create the GKE cluster
- [x] Get cluster credentials (`/root/.kube/config` file)
- [x] Initialize Helm

## Cluster access control

- [ ] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

## Supporting tools

- [x] Install cluster ingress controller (cloud load balancer)
- [x] Install TLS certificates controller (kube-lego)
- [ ] Install Continuous Delivery tools
    - [x] Continuous delivery service (Drone / Jenkins)
    - [x] Helm chart repository (ChartMuseum)
    - [x] Private Docker registry
    - [ ] Git service (Gitlab / Gogs)
- [ ] Monitoring and alerting tools (Prometheus / Grafana)

## User apps and services

- [x] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.
