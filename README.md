# Exekube

⚠️ This is a work in progress. Don't attempt to use it for anything except developing Exekube (or inspiration).

## Introduction

*Exekube* is a declarative "Infrastructure as Code" framework (a.k.a. platform / PaaS) for managing cloud infrastrucutre (including Kubernetes clusters) and deploying containerized software onto that infrastructure.

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

| Component | Purpose |
| --- | --- |
| Docker and Docker Compose | Local development environment |
| Terraform | Declarative infrastructure and deployment management |
| Terragrunt | Terraform *live module* management |
| Kubernetes | Container orchestration |
| Helm | Kubernetes package (chart / release) management |

### Default Helm packages installed in-cloud

| Component | Purpose |
| --- | --- |
| NGINX Ingress Controller | Cluster ingress controller |
| kube-lego | Automatic Let's Encrypt TLS certificates for Ingress |
| HashiCorp Vault | Cluster secret management |
| Docker Registry | Container image registry |
| ChartMuseum | Helm chart repository |
| Jenkins, Drone, or Concourse | Continuous integration |

## Setup and usage

### Requirements starting from zero

- For Linux user, [Docker CE](/) and [Docker Compose](/) are sufficient
- For macOS users, [Docker for Mac](/) is sufficient
- For Windows users, [Docker for Windows](/) is sufficient

### Initial setup: cloud provider billing and access

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
    xk apply live/prod/kube/apps/rails-app/

    xk apply live/prod/kube/
    xk destroy live/prod/kube/
    ```

#### Cleanup

6. Clean everything up:

    ```sh
    # Destroy all cloud provider and Kubernetes resources
    xk destroy
    ```

### Comparing Workflows - imperative CLI vs declarative HCL+YAML

#### ✅ Declarative workflow (.tf and .tfvars files)

- `xk apply`
- `xk destroy`

Declarative tools are exact equivalents of stadard CLI tools like `gcloud` / `aws`, `kubectl`, and `helm`, except everything is implemented as a [Terraform provider plugin](/) and expressed as declarative HCL (HashiCorp Language) code.

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
