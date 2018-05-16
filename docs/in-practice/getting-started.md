# Getting started with Exekube

## What we'll build

In this tutorial, we'll walk through the steps of creating a new Exekube project with a Kubernetes cluster in it:

<p align="center">
  <img src="/images/screenshot.png" alt="The Kubernetes Dashboard"/>
</p>

We'll then proceed to write code for a brand-new Helm chart (YAML + Go templates) and a Helm release (Terraform / HCL code) using the [helm-release module](/) from Exekube's [module library](/):

<p align="center">
  <img src="/images/nginx-app-screenshot.png" alt="The Nginx app release that uses a basic Helm chart"/>
</p>

## Step 0: Prerequisites

Before we begin, ensure that:

- You have a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you have [Docker Community Edition](https://www.docker.com/community-edition) installed

## Step 1: Clone the Git repository

1. Clone the Git repo of the [base-project](https://github.com/exekube/base-project):

```sh
git clone https://github.com/exekube/base-project
cd base-project
```

2. Create an alias for your shell session:

```sh
alias xk='docker-compose run --rm xk'
```

??? question "Why is this necessary?"

    Exekube is distributed in a Docker image to save us from managing dependencies like `gcloud`, `terraform`, `terragrunt`, or `kubectl` on our workstation.

    To create a Docker container from the image, we use Docker Compose. Check the `docker-compose.yaml` file in the root of our repository to see how the image is used.

    The alias for our bash session is used to purely save us from typing `docker-compose run --rm exekube` every time we want to interact with the repository.

## Step 2: Configure the project and its environments

??? question "What is an environment?"

    We will usually deploy our project into several *environments*, such as dev, stg, test, prod, etc.  Each environment corresponds to a separate *GCP project* with a globally unique ID. This allows us to fully isolate environments from each other.

    Read more about GCP projects here: https://cloud.google.com/resource-manager/docs/creating-managing-projects

Set the *GCP project name base* in `docker-compose.yaml`:

```diff
services:
  xk:
    image: exekube/exekube:0.3.0-google
    working_dir: /project
    environment:
      # ...
-     TF_VAR_project_id: ${ENV}-demo-apps-296e23
+     TF_VAR_project_id: ${ENV}-my-project-09345g
```

## Step 3: Initialize dev environment

Once we've set all the variables for each Terraform module, we can create the GCP project for our environment.

1. Set shell variables:

    ```sh
    export ENV=dev
    export ORGANIZATION_ID=<YOUR-ORGANIZATION-ID>
    export BILLING_ID=<YOUR-BILLING-ID>
    ```

2. Log yourself into the Google Cloud Platform (follow on-screen instructions):

    ```sh
    xk gcloud auth login
    ```

3. Run the `gcp-project-init` script:

    ```diff
    xk gcp-project-init
    ```

??? question "What will this script do?"

    The script will:

    - Create a GCP project with the `$TF_VAR_project_id` ID we specified earlier
    - Create a GCP Service Account for use with Terraform, give it project owner permissions, and download its JSON-encoded key to the path at `$TF_VAR_serviceaccount_key`
    - Create a GCS bucket for Terraform remote state, named `$TF_VAR_project_id`-tfstate

    Read the source code of the script here: https://github.com/exekube/exekube/blob/master/modules/gcp-project-init/gcp-project-init

## Step 4: Create and manage cloud infrastructure

Now that we have an empty GCP project set up for our environment, we will use Terraform and Terragrunt to manage all resources in it. Let's use the `gke-network` to create a VPC for our GKE cluster:

```sh
# Recursively looks for terraform.tfvars files in the subdirectories
#   of the specified path
# Imports and applies Terraform modules
xk up live/dev/infra
```

Terraform modules in `live/<ENV>/infra` are "persistent", meaning that once we've created an environment, we can keep them in the "always created" state. Reasons for not cleaning them up for non-production environments:

- Networking services (VPN, DNS) often don't cost anything on cloud platforms
- DNS records don't handle rapid changes well. It's more practical to have static IP addresses and DNS records

## Step 5: Create and manage a cluster and all Kubernetes resources

We can now create the cluster (gke-cluster module) and create all Kubernetes resources (helm-release modules) via one command:

```sh
# Since we don't specify path as an argument, it will use $TF_VAR_default_dir
xk up
```

## Step 6: (Optional) Deploy an nginx app

Let's add a basic Terraform module and a Helm chart to deploy *myapp*, an nginx app, into our Kubernetes cluster:

1. First, let's create the project module:
    ```sh
    mkdir modules/myapp
    cat <<'EOF' > modules/myapp/main.tf
    ```
    ```tf
    # modules/myapp/main.tf
    terraform {
      backend "gcs" {}
    }

    variable "secrets_dir" {}

    module "myapp" {
      source           = "/exekube-modules/helm-release"
      tiller_namespace = "kube-system"
      client_auth      = "${var.secrets_dir}/kube-system/helm-tls"

      release_name      = "myapp"
      release_namespace = "default"

      chart_name = "nginx-app/"
    }
    ```
    ```sh
    EOF
    ```

2. Next, we will create a local Helm chart and release values for it:

    ```sh
    # Create a brand-new Helm chart
    xk helm create nginx-app

    # Move the chart into modules/myapp
    mv nginx-app modules/myapp/

    # Create values.yaml for myapp Helm release
    cp modules/myapp/nginx-app/values.yaml modules/myapp/
    ```

3. Add the module into live/dev environment:
    ```sh
    mkdir -p live/dev/k8s/default/myapp
    ```
    ```sh
    cat <<'EOF' > live/dev/k8s/default/myapp/terraform.tfvars
    ```
    ```tf
    # ↓ Module metadata
    terragrunt = {
      terraform {
        source = "/project/modules//myapp"
      }

      dependencies {
        paths = [
          "../../kube-system/helm-initializer",
        ]
      }

      include = {
        path = "${find_in_parent_folders()}"
      }
    }

    # ↓ Module configuration (empty means all default)
    ```
    ```sh
    EOF
    ```

4. Update your cluster:
    ```sh
    xk up
    ```

5. Create a TLS tunnel (`kubectl proxy`) to our `localhost:8001`:
    ```sh
    docker-compose up -d
    ```
    Go to <http://localhost:8001/api/v1/namespaces/default/services/myapp-nginx-app:80/proxy/>

    <p align="center">
      <img src="/images/nginx-app-screenshot.png" alt="The Nginx app release that uses a basic Helm chart"/>
    </p>

### Making upgrades

All configuration is declarative, so just modify any module's variables and run `xk up` again to upgrade the cluster's state.

You can also create, upgrade, or destroy single modules or namespaces by specifying a path as an argument to `xk up` or `xk destroy`:

```sh
# Use bash completion 👍
#
# Apply only one module
xk up live/dev/k8s/default/myapp/
# Destroy only one module
xk down live/dev/k8s/default/myapp/

# Apply all modules in default directory
xk up live/dev/k8s/default/
# Destroy all modules in default directory
xk down live/dev/k8s/default/
```

## Step 7: Clean up

1. When you are done with your dev environment, run this command to destroy the GKE cluster and all Kubernetes / Helm resources (the important parts):
    ```sh
    # Again, since we don't specify path as an argument, it will
    #   use $TF_VAR_default_dir
    xk down
    ```

    These resources are highly ephemeral in non-production environments, meanining that you can `xk up` and `xk down` several times per day / per hour. Google Compute Engine (GCE) running instances (Kubernetes worker nodes) are quite expensive (especially for more intensive workloads), so we want to only keep them running when needed.

2. Clean up networking resources (⚠️ not recommended)
    ```sh
    xk down live/dev/infra
    ```
    These resources (except reserving a static IP address) are free on Google Cloud Platform, so we recommend you keep them always created.

3. Clean up the GCP project (⚠️ not recommended)

    There's no automation for destroying a GCP project and starting over. Billing-enabled projects are subject to strict quotas if you are using the Google Cloud Platform free trial, so we recommend to purge projects (delete resources manually) instead deleting the project itself.

## What's next?

- Configure production-grade networking: http://docs.exekube.com/in-practice/production-networking/

- Configure production-grade storage: http://docs.exekube.com/in-practice/production-storage/

- Check out [this pull request on GitHub](/) to see how to deploy the Guestbook app from [kubernetes/examples](/)

- Take a look at Exekube example projects: https://docs.exekube.com/introduction/what-is-exekube#examples
