# Demo Exekube Project: demo-ci-project

An example cloud project built with the [Exekube framework](https://github.com/exekube/exekube)

> :warning:
>
> This is a work in progress
>
> :warning:

## Project modules

| Project component | Type | Purpose |
| --- | --- |
| [project-init](/) | Bash script | Create a [Google Cloud Platform project](/) |
| [gcp-project](/) module | Configure networking for the project, including subnets, static IP addresses for ingress, DNS zones and records |
| [gke-cluster](/) module | Create / upgrade / destroy a Google Kubernetes Engine (GKE) cluster, node pools |
| [helm-initializer](/) module (`_helm` directories) | Deploy Tiller and create certificates / private keys for mutual TLS authentication between Helm and Tiller |
| [cluster-admin](/) chart | Create / upgrade / destroy Kubernetes namespaces, roles, rolebindings, networkpolicies, etc. |
| [ingress-controller](/) chart | Create / upgrade / destroy an nginx-ingress Kubernetes ingress controller |
| [kube-lego](/) chart | Automatically create / update Let's Encrypt TLS certificates for ingress |
| [concourse](/) chart | ... |
| [docker-registry](/) chart | ... |
| [chartmuseum](/) chart | ... |
...

## Quickstart configuration checklist

For every environment, there will be some unique things that you will need to configure depending on your use case and whether we're in a playground (dev), staging (stg), or production (prod) enrvironment.

### Global

- [ ] `TF_VAR_project_id` variable in [live/.env](/): the ID of your GCP project to create via `project-init` script and then use via every Terraform module

### live/dev/project module

- [ ] `dns_zones` and `dns_records` in [live/dev/project/terraform.tfvars](/) for your Concourse server, Docker registry, and Chartmuseum ingresses

### live/dev/kubernetes/kube-system/ingress-controller

- [ ] If you want to use a static external IP address for nginx-ingress, uncomment `conroller.service.loadBalancerIP` in `live/dev/project/kubernetes/kube-system/ingress-controller/values.yaml` (using the output of `xk output live/dev/project`)

### live/dev/kubernetes/kube-system/kube-lego

- [ ] Replace staging Let's Encrypt TLS server with the real one in `live/dev/kubernetes/kube-system/kube-lego/values.yaml`:

    ```diff
    - LEGO_URL: https://acme-staging.api.letsencrypt.org/directory
    + LEGO_URL: https://acme-v01.api.letsencrypt.org/directory
    ```

... to be continued ...

## Getting started with an Exekube project

## Project directory structure

The `live` directory contains configuration for every environment (dev, stg, prod) for this product.

```sh
├── live/
│   ├── dev/
│   ├── stg/
│   ├── prod/
│   ├── .env # Common TF_VARs -- variables shared by multiple modules
│   └── terraform.tfvars # Terraform / Terragrunt config for modules (e.g. remote state config)
```

Every environment (dev, stg, test, prod, etc.) directory is further broken down into directories that contain resources (cloud resources) of these categories:

```sh
live/
├── dev/
│   ├── project/
│   ├── kubernetes/
│   ├── secrets/
│   ├── .env
│   └── ci.yaml
├── stg/
│   ├── project/
│   ├── kubernetes/
│   ├── secrets/
│   ├── .env
│   └── ci.yaml
├── prod/
│   ...
```

Explore the directory structure (https://github.com/exekube/demo-ci-project/tree/master/live/dev) and use this table for reference:

| Configuration types for every environment | What's in there? |
| --- | --- |
| `project` | ☁️ Google Cloud resources, e.g. project settings, network, subnets, firewall rules, DNS |
| `kubernetes` | ☸️ GKE cluster configuration, Kubernetes API resources and Helm release configuration |
| `secrets` | 🔐 Secrets specific to this environment, stored and distributed in GCS (Cloud Storage) buckets and encrypted by Google Cloud KMS encryption keys |
| `.env` | 🔩 Environment-specific variables common to several modules |
| `ci.yaml` | ✈️ Concourse pipeline [manifest for CI pipelines](https://github.com/concourse/concourse-pipeline-resource#dynamic) |

# Getting started

## Prerequisites

- You'll need a Google Account with access to an [Organization resource](https://cloud.google.com/resource-manager/docs/quickstart-organizations)
- On your workstation, you'll need to have [Docker Community Edition](https://www.docker.com/community-edition) installed

## Bootstrap your Exekube project

First, clone a Git repository of one of the demo projects:

```sh
git clone https://github.com/exekube/demo-ci-project
```

## Configure project files

For our new project, we begin by picking an environment for it first:

```sh
export ENV=dev
```



The meat of any project developed with Exekube is declarative code expressed as:

- `TF_VAR_*` environmental variables common to multiple Terraform modules or
- `*.tfvars` files that contain module-specific variables

<!---

### Global .env file

> This is used only for bootstrapping a [Google Cloud Platform project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) for every (dev, staging, testing, production) environment via the [project-init script](https://github.com/exekube/exekube/blob/master/modules/scripts/project-init)

```sh
# live/.env
ORGANIZATION_ID=889071810646
BILLING_ID=01A70D-9FAAFB-40FF75
```

-->

### Environment-specific .env file

Environment (shell) variables starting with `TF_VAR` can be accessed by multiple Terraform modules. We do this to avoid repeating input variables in `.tfvars` files.

In `live/dev/.env`:

```sh
TF_VAR_project_id=dev-demo-ci-296e23 # Modify to set your project's globally unique ID!
TF_VAR_serviceaccount_key=/project/live/dev/secrets/kube-system/owner.json
TF_VAR_default_dir=/project/live/dev/kubernetes
TF_VAR_secrets_dir=/project/live/dev/secrets
TF_VAR_keyring_name=keyring
```

Notice that all paths (/project/**) are from within a Docker container, configured in the `docker-compose.yaml` file in the root of the project's repo.

### Terraform and Terragrunt module configuration

Once we set the variables for the environment, we can begin configuring Terragrunt modules.

1. ☁️ We configure the `gcp-project` module in `live/dev/project/terraform.tfvars`.
    - [gcp-project module API reference](https://github.com/exekube/exekube/blob/master/modules/gcp-project/variables.tf): module for enabling APIs for the GCP project, configuring networking, firewall rules, external IP addresses, DNS, etc.


2. ☸️ We create, administer, and use a GKE cluster via the subdirectories of `live/dev/kubernetes`, using one of the framework's built-in modules:
    - [helm-initializer module API reference](https://github.com/exekube/exekube/tree/master/modules/helm-initializer): module for generating TLS certificates and keys for Helm and Tiller and running `helm init`
    - [helm-release module API reference](https://github.com/exekube/exekube/blob/master/modules/helm-release/variables.tf): module for installing a generic Helm chart

3. 🔐 We store and distribute secrets securely:

    - [gcp-kms-secret-mgmt module API reference](https://github.com/exekube/exekube/tree/master/modules/gcp-kms-secret-mgmt): module for storing / distributing secrets in GSC buckets and encrypting them transparently via Cloud KMS encryption keys
    - ...

# Framework's Workflow

## 1. Bootstrap a GCP Project for use with Terraform

```sh
alias xk='docker-compose run --rm exekube'
```

We are now ready to create a GCP project for our dev environment. This is done via a script ([source](https://github.com/exekube/exekube/blob/master/modules/scripts/project-init)):

```diff
xk project-init
+ ...
+ Finished successfully!
```

The script will:

- Create a GCP project with the `$TF_VAR_project_id` ID we specified earlier
- Create a GCP Service Account for use with Terraform, give it project owner permissions, and download its JSON-encoded key to the path at `$TF_VAR_serviceaccount_key`
- Create a GCS bucket for Terraform remote state, named `$TF_VAR_project_id`-tfstate

## Manage GCP resources (live/dev/project) declaratively

We can use Terraform + Terragrunt from here 👌

First, we apply the [gcp-project](https://github.com/exekube/exekube/tree/master/modules/gcp-project) module, which will:

- Enable GCP APIs for the project
- Set up networking for our Kubernetes cluser
- Create firewall rules
- Create static IP addresses
- DNS zones and records, etc.

```sh
xk up live/dev/project
```

Networking and small storage resources cost very little on GCP, so we keep them created at all times for all (including non-production) environments.

Running clusters, on the other hand, costs the same as running Google Compute Engine (GCE) VMs, which is a lot more expensive.

## Manage Kubernetes & Helm resources (live/dev/kubernetes) declaratively

We can now create the cluster and create all Kubernetes resources via one command:

```sh
xk up
```

All configuration is declarative, so when you need to update something, just change the code live `live/dev/kubernetes/**` and run `xk up` to refresh the cluster's state. You can also create, upgrade, or destroy single modules or namespaces by specifying a path after `xk up` or `xk destroy` (under the hood `xk up` calls `cd <module-dir> & terragrunt apply-all`):

```sh
xk up live/dev/kubernetes/kube-system/ingress-controller/
xk down live/dev/kubernetes/kube-system/ingress-controller/

xk up live/dev/kubernetes/team1
xk down live/dev/kubernetes/team1
```

Once your are done with you tests in non-production envrironments, you can run

```sh
xk down
```

to destroy all Kubernetes (and Helm) resources (and the underlying infrastructure such as GCE Persistent Disks and Load Balancers) and then destroy the cluster.

These resources can be highly ephemeral in non-production environments, meanining that you can `xk up` and `xk down` several times per day / per hour. GCE running instances are quite expensive (especially for more intensive workloads), so we only keep them running when needed.

# Contributions

Contributions are welcome!
