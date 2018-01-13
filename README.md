⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

# Exekube

*Exekube* is a declarative "Infrastructure as Code" framework for administering Kubernetes clusters and deploying containerized software onto them. Exekube offers you full control over your infrastructure and container orchestration while also having a great default state with a *one-click-to-deploy* experience.

Here is a quick example of how you'd deploy Jenkins using Exekube (a Terraform module):

```tf
# live/prod/ci/jenkins/inputs.tfvars

release_spec = {
  enabled        = true
  release_name   = "ci"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "jenkins"
  chart_version = "0.12.0"

  domain_name = "ci.example.pw"
}
```

## Introduction

You only need [Docker CE](/) and [Docker Compose](/) on your local machine to begin using Exekube. The framework is a thin layer on top of several open-source DevOps tools:

- Docker Compose (for our local development environment)
- Terraform, Terragrunt, and HCL (HashiCorp Configuration Language)
- Kubernetes
- Helm

Exekube allows you to manage both cloud infrastructure resources and Kubernetes resources using a git-based workflow with a continuous integration (CI) pipeline.

📘 Read the companion guide: <https://github.com/ilyasotkov/learning-kubernetes/>

- [Introduction](#introduction)
- [Design principles](#design-principles)
- [Setup and usage](#setup-and-usage)
	- [Requirements starting from zero](#requirements-starting-from-zero)
		- [Linux](#linux)
		- [macOS](#macos)
		- [Windows](#windows)
	- [Usage step-by-step](#usage-step-by-step)
		- [Cloud provider setup: do it once](#cloud-provider-setup-do-it-once)
		- [Cluster setup: do it as often as you need](#cluster-setup-do-it-as-often-as-you-need)
	- [Workflows](#workflows)
		- [Legacy imperative workflow (CLI)](#legacy-imperative-workflow-cli)
		- [Declarative workflow (.tf and .tfvars files)](#declarative-workflow-hcl-tf-files)
- [Feature tracker](#feature-tracker)
	- [Cloud provider and local environment setup](#cloud-provider-and-local-environment-setup)
	- [Cloud provider config](#cloud-provider-config)
	- [Cluster creation](#cluster-creation)
	- [Cluster access control](#cluster-access-control)
	- [Supporting tools](#supporting-tools)
	- [User apps and services](#user-apps-and-services)

## Design principles

- Everything on client side runs in a Docker container
- Infrastructure (cloud provider) objects and Kubernetes API objects are expressed as declarative code, using HCL (HashiCorp Language) and Helm packages (YAML + Go templates)
- Modular design
- Git-based workflow with a CI pipeline [TBD]
- No vendor lock-in, choose any cloud provider you want [only GCP for now]
- Test-driven (TDD) or behavior-driven (BDD) model of development [TBD]

## Setup and usage

### Requirements starting from zero

The only requirements, depending on your local OS:

#### Linux

- [Docker](/)
- [Docker Compose](/)

#### macOS

- [Docker for Mac](/)

#### Windows

- [Docker for Windows](/)

### Usage step-by-step

#### Cloud provider setup: do it once

0. Create `xk` (stands for "exekube") alias for your shell session (or save to ~/.bashrc):
    ```bash
    alias xk=". .env && docker-compose run --rm exekube"
    ```
1. Rename `.env.example` file in repo root to `.env`. Configure `${TF_VAR_gcp_project}` and `${TF_VAR_gcp_remote_state_bucket}` shell exports.
2. [Set up a Google Account](https://console.cloud.google.com/) for GCP (Google Cloud Platform), create a project named `${TF_VAR_gcp_project}`, and enable billing.
3. [Create a service account](/) in GCP Console GUI, give it project owner permissions.
4. [Download JSON credentials](/) ("key") to repo root directory and rename the file to `credentials.json`.
5. Use JSON credentials to authenticate us to `gcloud`:
    ```sh
    xk gcloud auth activate-service-account --key-file credentials.json
    ```
6. Create Google Cloud Storage bucket (with versioning) for our Terraform remote state:
    ```sh
    xk gsutil mb \
            -p ${TF_VAR_gcp_project} \
            gs://${TF_VAR_gcp_remote_state_bucket} \
    && xk gsutil versioning set on \
            gs://${TF_VAR_gcp_remote_state_bucket}
    ```

#### Cluster setup: do it as often as you need

7. Edit code in `live` and `modules` directories:

    ⚠️ If you cloned / forked this repo, you'll need to have a domain name (DNS zone) like `example.com` and have CloudFlare DNS servers set up for it.

    Then, in your text editor, search and replace `sotkov.pw` / `flexeption.pw` with your domain zones.

    [Guide to Terraform / Terragrunt, HCL, and Exekube directory structure](/) [TODO]

8. Deploy all *live modules* (the cluster and all Kubernetes resources):
    ```sh
    # Edit $XK_LIVE_DIR environmental variable in docker-compose.yaml to change the what the `apply` command deploys
    xk plan
    xk apply

    # You can also apply or destroy configuration for individual live modules
    xk apply live/prod/gcp-project/
    xk destroy live/prod/core/
    xk apply live/prod/apps/

    # To make the cluster dashboard available at localhost:8001/ui, run
    docker-compose up -d
    # To disable local dashboard, run `docker-compose down`
    ```

#### Cleanup

```sh
xk destroy
```

### Workflows

#### Legacy imperative workflow (CLI)

⚠️ These tools are relatively mature and work well, but are considered *legacy* here since this framework aims to be [declarative](/)

Command line tools `kubectl` and `helm` are known to those who are familiar with Kubernetes. `gcloud` (part of Google Cloud SDK) is used for managing the Google Cloud Platform.

- `xk gcloud`
- `xk kubectl`
- `xk helm`

Examples:

```sh
xk gcloud auth list

xk kubectl get nodes

xk helm install --name custom-rails-app \
        -f live/prod/kube-custom/values/rails-app.yaml \
        charts/rails-app
```

#### Declarative workflow (.tf and .tfvars files)

- `xk apply`
- `xk destroy`

Declarative tools are exact equivalents of the legacy imperative (CLI) toolset, except everything is implemented as a [Terraform provider plugin](/) and expressed as declarative HCL (HashiCorp Language) code. Instead of writing CLI commands like `xk helm install --name <release-name> -f <values> <chart>` for each individual Helm release, we install all releases simultaneously by running `xk apply`.

## Feature tracker

Features are marked with ✔️ when they enter the *alpha stage*, meaning a minimum viable solution has been implemented

### Cloud provider and local environment setup

- [x] Create GCP account, enable billing in GCP Console (web GUI)
- [x] Get credentials for GCP (`credentials.json`)
- [x] Authenticate to GCP using `credentials.json` (for `gcloud` and `terraform` use)
- [x] Enable terraform remote state in a Cloud Storage bucket

### Cloud provider config

- [ ] Create GCP Folders and Projects and associated policies
- [ ] Create GCP IAM Service Accounts and IAM Policies for the Project

### Cluster creation

- [x] Create the GKE cluster
- [x] Get cluster credentials (`/root/.kube/config` file)
- [x] Initialize Helm

### Cluster access control

- [ ] Add cluster namespaces (virtual clusters)
- [ ] Add cluster roles and role bindings
- [ ] Add cluster network policies

### Supporting tools

- [x] Install cluster ingress controller (cloud load balancer)
- [x] Install TLS certificates controller (kube-lego)
- [ ] Install Continuous Delivery tools
    - [x] Continuous delivery service (Drone / Jenkins)
    - [x] Helm chart repository (ChartMuseum)
    - [x] Private Docker registry
    - [ ] Git service (Gitlab / Gogs)
- [ ] Monitoring and alerting tools (Prometheus / Grafana)

### User apps and services

- [x] Install "hello-world" apps like static sites, Ruby on Rails apps, etc.
