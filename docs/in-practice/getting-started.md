# Getting started with Exekube

!!! warning
    This is a work in progress

## What we'll build

We have three demo projects for you to try out Exekube (sorted by degree of difficullty):

- [demo-apps-project](/)
- [demo-grpc-project](/)
- [demo-ci-project](/)

Once you've made your choice, grab the link of the repository.

## Step 0: Prerequisites

Before we begin, ensure that:

- You have a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you have [Docker Community Edition](https://www.docker.com/community-edition) installed

## Step 1: Clone the Git repository

1a. Clone the repo of the demo project you chose:

```sh
git clone https://github.com/exekube/demo-apps-project
cd demo-apps-project
```

1b. Create an alias for your bash session:

```sh
alias xk='docker-compose run --rm exekube'
```

??? question "Why is this necessary?"

    Exekube is distributed in a Docker image to save us from managing dependencies like `gcloud`, `terraform`, `terragrunt`, or `kubectl` on our workstation.

    To create a Docker container from the image, we use Docker Compose. Check the `docker-compose.yaml` file in the root of our repository to see how the image is used.

    The alias for our bash session is used to purely save us from typing `docker-compose run --rm exekube` every time we want to interact with the repository.

## Step 2: Configure Terraform modules for dev environement

??? question "What is an environment?"

    1 environment == 1 GCP project

    We will usually deploy our project into several *environments*, such as dev, stg, test, prod, etc.  Each environment corresponds to a separate *GCP project* with a globally unique ID. This allows us to fully isolate environments from each other.

We will start with the *dev* environment for our project. After we are done with the dev environment, we can continue and create a *stg or prod* environment.

Configuration is where our demo projects differ, so instructions for configuring each can be found in its README:

- [github.com/exekube/demo-apps-project](/)
- [github.com/exekube/demo-grpc-project](/)
- [github.com/exekube/demo-ci-project](/)

After you follow the README to configure the *dev* environment for your demo project, we can move on to step 3.

## Step 3: Initialize dev environment

Once we've set all the variables for each Terraform module, we can create the GCP project for our environment.

3a. Set shell variables:

```sh
export ENV=dev
export ORGANIZATION_ID=<YOUR-ORGANIZATION-ID>
export BILLING_ID=<YOUR-BILLING-ID>
```

3b. Log yourself into the Google Cloud Platform:

```sh
xk gcloud auth login
```

3c. Run the `project-init` script:

```diff
xk project-init
```

??? question "What will this script do?"

    The script will:

    - Create a GCP project with the `$TF_VAR_project_id` ID we specified earlier
    - Create a GCP Service Account for use with Terraform, give it project owner permissions, and download its JSON-encoded key to the path at `$TF_VAR_serviceaccount_key`
    - Create a GCS bucket for Terraform remote state, named `$TF_VAR_project_id`-tfstate

    Read the source code of the script here: https://github.com/exekube/exekube/blob/master/modules/scripts/project-init

## Step 4: Create and manage cloud infrastructure

!!! note
    Now that we have a GCP project set up for our environment, we will use Terraform and Terragrunt to manage all resources declaratively.

Apply all infrastructure modules:

```sh
# Recursively looks for terraform.tfvars files in the subdirectories
#   of the specified path
# Imports and applies Terraform modules
xk up live/dev/infra
```

Terraform modules in `infra` are "persistent", meaning that once we've created an environment, we can keep them in the "always created" state. Reasons for not cleaning them up for non-production environments:

- Networking services (VPN, DNS) often don't cost anything on cloud platforms
- DNS records don't handle rapid changes well. It's more practical to have static IP addresses and DNS records

??? question "What resources do modules in infra create?"

    - Enable GCP APIs for the project
    - Create a network and subnets for our Kubernetes cluster(s)
    - Create firewall rules
    - Create static IP addresses
    - DNS zones and records, etc.

    These resources cost very little compared to running GCE instances (GKE worker nodes), so we keep them created at all times for all (including non-production) environments.

## Step 5: Create and manage a cluster and all Kubernetes resources

We can now create the cluster (gke-cluster module) and create all Kubernetes resources (helm-release modules) via one command:

```sh
# Since we don't specify path as an argument, it will use $TF_VAR_default_dir
xk up
```

### Making upgrades

All configuration is declarative, so just modify any module's variables and run `xk up` again to upgrade the cluster's state.

You can also create, upgrade, or destroy single modules or namespaces by specifying a path as an argument to `xk up` or `xk destroy`:

```sh
# Apply only one module
xk up live/dev/kubernetes/kube-system/ingress-controller/
# Destroy only one module
xk down live/dev/kubernetes/kube-system/ingress-controller/

# Apply all modules in team1 directory
xk up live/dev/kubernetes/team1
# Destroy all modules in team1 directory
xk down live/dev/kubernetes/team1
```

## Clean up

When you are done with your dev environment, run this command to destroy the GKE cluster and all Kubernetes / Helm resources:

```sh
# Again, since we don't specify path as an argument, it will
#   use $TF_VAR_default_dir
xk down
```

to destroy all Kubernetes (and Helm) resources and then destroy the cluster.

These resources are highly ephemeral in non-production environments, meanining that you can `xk up` and `xk down` several times per day / per hour. GCE running instances are quite expensive (especially for more intensive workloads), so we want to only keep them running when needed.
