# What is Exekube?

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm.

## Motivation

Using many command line tools (or GUIs) to manage cloud resources (e.g. `gcloud`, `aws`, `kops`) and Kubernetes resources (e.g. `kubectl`, `helm`) is tedious and error-prone.

Terraform is a very flexible declarative tool with support for a [large number](https://www.terraform.io/docs/providers/index.html) of cloud providers and can replace all of the said command line tools and give us a single "Everything as Code" fully automated workflow.

Exekube aims to take advantage of Terraform's power and give us a "sane default" state for managing Kubernetes as declarative code.

## Sample workflow

!!! done "**TL;DR**"
    Spin up and destroy a Kubernetes cluster and all Kubernetes resources:
    ```bash
    xk apply && xk destroy
    ```

1. **Initial setup**: Create an empty project for your deployment environment on a cloud platform like Amazon Web Services (AWS) or Google Cloud Platform (GCP) and get credentials for it. This is only done once for every deployment environment.

    [Tutorial for Google Cloud Platform](/setup/gcp-gke/)

2. **Edit code**: Configure your project by editing Terraform (HCL) files in a text editor of your choice.

    [Guide to Exekube directory structure and framework usage](/usage/directory-structure) ● [Example directory structure](https://github.com/ilyasotkov/exekube/tree/develop/live/prod)

3. **Create a project**: Run `xk apply` to deploy everything onto the cloud platform, including cloud infrastructure and Kubernetes resources.
4. **Update the project**: Edit Terraform code in face of changing requirements and run `xk apply` again to match the state of your code to the state of real-world resources.
5. **Destroy the project**: Run `xk destroy` to clean everything up.

This workflow is an excellent fit for creating easy-to-understand continuous integration pipelines.

## Features

The framework offers you:

- Full control over your cloud infrastructure (via Terraform)
- Full control over your container orchestration (via Terraform + Helm)
- Fully automated one-command-to-deploy experience
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

| Component | Role |
| --- | --- |
| NGINX Ingress Controller | Cluster ingress controller |
| kube-lego | Automatic Let's Encrypt TLS certificates for Ingress |
| HashiCorp Vault (TBD) | Cluster secret management |
| Docker Registry | Container image registry |
| ChartMuseum | Helm chart repository |
| Jenkins, Drone, or Concourse | Continuous integration |
