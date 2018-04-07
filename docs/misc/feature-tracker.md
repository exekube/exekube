# Demo Exekube Project: demo-ci-project

!!! warning
    This is a work in progress

## Overview

This project will allow you to deploy:

- A Concourse server -- self-hosted CI / CD service (<https://concourse-ci.org>)
- A private Docker Registry (https://docs.docker.com/registry)
- A private ChartMuseum repository for hosting Helm charts (https://github.com/kubernetes-helm/chartmuseum)

## Prerequisites

- You'll need a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you'll need to have [Docker Community Edition](https://www.docker.com/community-edition) installed

## Step 1: Clone the Git repository

First, clone the repo of this demo project:

```sh
git clone https://github.com/exekube/demo-ci-project
cd demo-ci-project
```

Then, create an alias for your bash session:

```sh
alias xk='docker-compose run --rm exekube'
```

??? question "Why is this necessary?"

    Exekube is distributed in a Docker image to save us from managing dependencies like `gcloud`, `terraform`, `terragrunt`, or `kubectl` on our workstation.

    To create a Docker container from the image, we use Docker Compose. Check the `docker-compose.yaml` file in the root of our repository to see how the image is used.

    The alias for our bash session is used to purely save us from typing `docker-compose run --rm exekube` every time we want to interact with the repository.

## Step 2: Configure Terraform modules for an environement

??? question "What is an environment?"

    We will usually deploy our project into several *environments*, such as dev, stg, test, prod, etc.  Each environment corresponds to a separate *GCP project* with a globally unique ID. This allows us to fully isolate environments from each other.

We will start with the **dev** environment for our project.

Each environment consists of a number of configured Terraform modules, each with its unique `terraform.tfvars` file:

```sh
# live/dev
.
├── project
│   └── terraform.tfvars
├── kubernetes
│   ├── cluster
│   │   └── terraform.tfvars
│   ├── default
│   │   ├── _helm
│   │   │   └── terraform.tfvars
│   │   ├── chartmuseum
│   │   │   ├── terraform.tfvars
│   │   │   └── values.yaml
│   │   ├── concourse
│   │   │   ├── terraform.tfvars
│   │   │   └── values.yaml
│   │   └── docker-registry
│   │       ├── terraform.tfvars
│   │       └── values.yaml
│   └── kube-system
│       ├── _helm
│       │   └── terraform.tfvars
│       ├── cluster-admin
│       │   ├── terraform.tfvars
│       │   └── values.yaml
│       ├── ingress-controller
│       │   ├── terraform.tfvars
│       │   └── values.yaml
│       └── kube-lego
│           ├── terraform.tfvars
│           └── values.yaml
...
```

But first, we will configure variables that will be used by multiple Terraform modules.

### Shared variables

We can share variables between multiple modules by setting shell variables starting with `TF_VAR_`:

```sh hl_lines="5"
# live/dev/.env

# TF_VAR_project_id is used to create a GCP project for our environment
# It's then used by modules to create resources for the environment
TF_VAR_project_id=dev-demo-ci-296e23 # MODIFY!!!

# TF_VAR_serviceaccount_key will be used to put the service account key
#   upon the creation of the GCP project
# It will then be used by modules to authenticate to GCP
TF_VAR_serviceaccount_key=/project/live/dev/secrets/kube-system/owner.json

# TF_VAR is the default directory for Terraform / Terragrunt
# Used when we run `xk up` or `xk down` without an argument
TF_VAR_default_dir=/project/live/dev/kubernetes

# TF_VAR_secrets_dir is used by multiple modules to source secrets from
TF_VAR_secrets_dir=/project/live/dev/secrets

# Keyring is used by the gcp-kms-secret-mgmt module
# Also by secrets-fetch and secrets-push scripts
# The GCP KMS keyring name to use
TF_VAR_keyring_name=keyring
```

To get started with the demo project, you will only need to modify the highlighted line to set a unique ID for your GCP project.

### Module-specific variables

The demo-ci-project consists of these modules (all are Exekube built-in modules).

- gcp-project
- gke-cluster
- helm-initializer (_helm)
    - kube-system namespace
    - default namespace
- helm-release
    - cluster-admin
    - ingress-controller
    - kube-lego
    - concourse
    - docker-registry
    - chartmuseum

Below we highlighted some variables we want to set to make sure everything is functional:

1. In [live/dev/project/terraform.tfvars](/), set `dns_zones` and `dns_records` variables. These will automatically point to the static regional IP address that we create for our ingress-controller.
2. In [live/dev/kubernetes/kube-system/cluster-admin/values.yaml](/), make sure `projectAdmins` variable has `projectowner@<YOUR-PROJECT-id>.iam.gserviceaccount.com` in it.
3. In [live/dev/kubernetes/kube-system/ingress-controller/values.yaml](/), make sure the variable `service.loadBalancerIP` is set to the static IP address we'll get as an output from `gcp-project` module.
4. In [live/dev/kubernetes/default/concourse/terraform.tfvars](/) set the `release_spec.domain_name` to a domain name from the `dns_records` variable in step 1.
5. Create a Kubernetes secret for Concourse and put into live/dev/secrets/default/concourse/secrets.yaml. Read the stable/concourse instructions about how to create the secret. If you will use GitHub OAuth for authenticating to Concourse, set that up as well.
6. Create basic-auth-username and basic-auth-password files for use with docker-registry and chartmuseum releases.

## Step 3: Initialize an environment

Once we've set all the variable for each Terraform module, we can create the GCP project for our environment:

```sh
export ENV=dev
export ORGANIZATION_ID=<YOUR-ORGANIZATION-ID>
export BILLING_ID=<YOUR-BILLING-ID>
```

```diff
xk project-init
```

??? question "What will this script do?"

    The script will:

    - Create a GCP project with the `$TF_VAR_project_id` ID we specified earlier
    - Create a GCP Service Account for use with Terraform, give it project owner permissions, and download its JSON-encoded key to the path at `$TF_VAR_serviceaccount_key`
    - Create a GCS bucket for Terraform remote state, named `$TF_VAR_project_id`-tfstate

    Read the source code of the script here: https://github.com/exekube/exekube/blob/master/modules/scripts/project-init

## Step 4: Create and manage networking resources

Now that we have a GCP project set up for our environment, we will use Terraform and Terragrunt to manage all resources declaratively.

Apply the gke-network module:

```sh
xk up live/dev/infra/network
```

??? question "What resources does this module create?"

    - Enable GCP APIs for the project
    - Create a network and subnets for our Kubernetes cluster(s)
    - Create firewall rules
    - Create static IP addresses
    - DNS zones and records, etc.

    These resources cost very little compared to running GCE instances (GKE worker nodes), so we keep them created at all times for all (including non-production) environments.

## Step 5: Create and manage a cluster and all Kubernetes resources

We can now create the cluster (gke-cluster module) and create all Kubernetes resources (helm-release modules) via one command:

```sh
xk up
```

### Making upgrades

All configuration is declarative, so just modify any module's variables and run `xk up` again to upgrade the cluster's state.

You can also create, upgrade, or destroy single modules or namespaces by specifying a path as an argument to `xk up` or `xk destroy`:

```sh
xk up live/dev/kubernetes/kube-system/ingress-controller/
xk down live/dev/kubernetes/kube-system/ingress-controller/

xk up live/dev/kubernetes/team1
xk down live/dev/kubernetes/team1
```

## Clean up

To clean up, just run

```sh
xk down
```

to destroy all Kubernetes (and Helm) resources and then destroy the cluster.

These resources are highly ephemeral in non-production environments, meanining that you can `xk up` and `xk down` several times per day / per hour. GCE running instances are quite expensive (especially for more intensive workloads), so we want to only keep them running when needed.
