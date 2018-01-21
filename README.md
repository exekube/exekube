# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## What is Exekube?

*Exekube* is a declarative "Infrastructure as Code" framework (a.k.a. platform / PaaS) for managing cloud infrastructure (notably Kubernetes clusters) and deploying containerized software onto that infrastructure.

### The workflow

Right after you enable billing on a cloud platform like Amazon Web Services or Google Cloud, you are able to run one command, `xk apply`, in order to:

- Create a Kubernetes cluster and supporting resources on the cloud platform
- Deploy various Kubernetes resources onto the cluster (as Helm releases)

When it's time to upgrade some of your cloud resources, just modify the code in the [live modules directory](https://github.com/ilyasotkov/exekube/tree/develop/live) and run `xk apply` again. Terraform will match the state of your code to the state of your cloud resources.

To clean up, run `xk destroy` and the whole thing is gone from the cloud.

Go through the [Usage section](/) to see a full example in action.

## Features

Exekube offers you:

- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-click-to-deploy experience
- Modular design and declarative model of management
- Freedom to choose a cloud provider to host Kubernetes
- Continuous integration (CI) facilities out of the box

## Components

The framework is distributed as a [Docker image on DockerHub](/) that can be used manually by DevOps engineers or automatically via continuous integration (CI) pipelines. It combines several open-source DevOps tools into one easy-to-use workflow for managing cloud infrastructure and Kubernetes resources.

### DevOps tools

| Component | Role |
| --- | --- |
| Docker | Local and cloud container runtime |
| Docker Compose | Local development enviroment manager |
| Terraform | Declarative cloud infrastructure manager |
| Terragrunt | Terraform *live module* manager |
| Kubernetes | Container orchestrator |
| Helm | Kubernetes package (chart / release) manager |

### Default Helm packages installed

| Component | Purpose |
| --- | --- |
| NGINX Ingress Controller | Cluster ingress controller |
| kube-lego | Automatic Let's Encrypt TLS certificates for Ingress |
| HashiCorp Vault (TBD) | Cluster secret management |
| Docker Registry | Container image registry |
| ChartMuseum | Helm chart repository |
| Jenkins, Drone, or Concourse | Continuous integration |

## Getting started

### Requirements starting from zero

- For Linux user, [Docker CE](/) and [Docker Compose](/) are sufficient
- For macOS users, [Docker for Mac](/) is sufficient
- For Windows users, [Docker for Windows](/) is sufficient

### Initial setup

1. First, create an alias for your shell session (`xk` stands for "exekube"):
    ```bash
    alias xk=". .env && docker-compose run --rm exekube"
    ```
2. If you don't have one, create a [Google Account](https://console.cloud.google.com/). Then, create a new [Google Cloud Platform Project](https://console.cloud.google.com).

    | Project name | Project ID |
    | --- | --- |
    | Production Environment | prod-env-20180101 |

3. Rename `.env.example` file in repo root to `.env`. Set the `TF_VAR_gcp_project` variable from previous step.
    ```bash
    export TF_VAR_gcp_project='prod-env-20180101'
    ```
4. [Create a service account](https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts) and give it project owner permissions. Download the account JSON private key filee to repo root directory and rename the file to `credentials.json`.
5. Run this command authenticate us to `gcloud`:
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

### Usage

#### Create and upgrade resources with just one command

1. Edit code in [`live`](/):

    > ⚠️ If you cloned / forked this repo, you'll need to have a domain name (DNS zone) like `example.com` and have CloudFlare DNS servers set up for it. Then, in your text editor, search and replace `swarm.pw` with your domain zone.

    [Guide to Terraform / Terragrunt, HCL, and Exekube directory structure](/)

2. Apply all *Terraform live modules* — create all cloud infrastructure and all Kubernetes resources:

    ```diff
    xk apply
    + ...
    + Module /exekube/live/prod/kube/apps/rails-app has finished successfully!
    ```
3. Enable the Kubernetes dashboard at <http://localhost:8001/ui>:

    ```sh
    docker-compose up -d
    ```

4. Go to <https://my-app.YOURDOMAIN.COM/> to check that a hello-world Rails app is running.
5. Upgrade the Rails application Docker image version in [live/kube/apps/my-app/values.yaml](/):

    ```diff
     replicaCount: 2
     image:
       repository: ilyasotkov/rails-react-boilerplate
    -  tag: "0.1.0"
    +  tag: "0.2.0"
       pullPolicy: Always
    ```

    Upgrade the state of real-world cloud resources to the state of our code in `live/prod` directory:
    ```sh
    xk apply
    ```
    Go back to your browser and check how your app updated with zero downtime! 😎

6. Experiment with creating, upgrading, and destroying single live modules and groups of live modules:

    ```sh
    xk destroy live/prod/kube/apps/rails-app/
    xk destroy live/prod/kube/apps/

    xk apply live/prod/kube/
    xk apply live/prod/kube/apps/rails-app/
    ```

#### Cleanup

7. Clean everything up:

    ```sh
    # Destroy all cloud provider and Kubernetes resources
    xk destroy
    ```

### Comparing Workflows - imperative CLI vs declarative HCL+YAML

#### ✅ Declarative workflow (.tf and .tfvars files)

- `xk apply`
- `xk destroy`

Declarative tools are exact equivalents of stadard CLI tools like `gcloud` / `aws`, `kubectl`, and `helm`, except everything is implemented as a [Terraform provider plugin](/) and expressed as declarative HCL (HashiCorp Configuration Language) code.

#### ⚠️ Legacy imperative workflow (CLI)

These tools are relatively mature and work well, but are considered *legacy* here since this framework aims to be [declarative](/).

Command line tools `kubectl` and `helm` are known to those who are familiar with Kubernetes. `gcloud` (part of Google Cloud SDK) is used for managing the Google Cloud Platform.

- `xk gcloud <group> <command> <arguments> <flags>`
- `xk kubectl <group> <command> <arguments> <flags>`
- `xk helm <command> <arguments> <flags>`

Examples:

```sh
xk gcloud auth list

xk kubectl get nodes

xk helm install --name custom-rails-app \
        -f live/prod/kube/apps/my-app/values.yaml \
        charts/rails-app
```
