# What is Exekube?

Exekube is an "Infrastructure as Code" modular framework for managing the whole lifecycle of Kubernetes-based projects. Exekube is built with Terraform, Terragrunt, and Helm as its developer interfaces.

## Motivation

Using many command line tools and GUIs to manage cloud resources (`gcloud`, `aws`, `kops`) and Kubernetes resources (`kubectl`, `helm`) is quite tedious and can be error-prone.

Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace all of the said command line tools.

Exekube takes advantage of Terraform's power to give us "sane default" state for managing everything related to Kubernetes **as declarative code** in a fully automated, modular, git-based workflow.

## Sample workflow

!!! done "**TL;DR**"
    Spin up and then destroy a Kubernetes cluster and all Kubernetes resources:
    ```bash
    xk up && xk down
    ```

1. **Initial setup**: Create an empty project for your deployment environment on a cloud platform like Amazon Web Services (AWS) or Google Cloud Platform (GCP) and get credentials for it. This is only done once for every deployment environment.

    [Tutorial for Google Cloud Platform](/setup/gcp-gke/)

2. **Edit code**: Configure your project by editing Terraform (HCL) files in a text editor of your choice.

    [Guide to Exekube directory structure and framework usage](/usage/directory-structure) ● [Example project](https://github.com/exekube/internal-ops-project)

3. **Create a project**: Run `xk up` to deploy everything onto the cloud platform, including cloud infrastructure and Kubernetes resources.
4. **Update the project**: Edit Terraform code in face of changing requirements and run `xk up` again to match the state of your code to the state of real-world resources.
5. **Destroy the project**: Run `xk down` to clean everything up.

This workflow is an excellent fit for creating easy-to-understand continuous integration pipelines.

## Features

The framework offers you:

- Docker-based cloud development environment with all necessary framework tools
- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-command-to-deploy `xk up` and `xk down` experience
- Modular design and declarative model of management
- Freedom to choose a cloud provider to host Kubernetes
- Continuous integration (CI) facilities out of the box

## Components

The framework is distributed as a [Docker image on DockerHub](https://hub.docker.com/r/ilyasotkov/exekube/) that can be used manually by DevOps engineers or automatically via continuous integration (CI) pipelines. It combines several open-source DevOps tools into one easy-to-use workflow for managing cloud infrastructure and Kubernetes resources.

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

| Component | Role |
| --- | --- |
| NGINX Ingress Controller | Cluster ingress controller |
| kube-lego | Automatic Let's Encrypt TLS certificates for Ingress |
| HashiCorp Vault (TBD) | Cluster secret management |
| Docker Registry | Container image registry |
| ChartMuseum | Helm chart repository |
| Jenkins, Drone, or Concourse | Continuous integration |
