# What is Exekube?

Exekube is an "Infrastructure as Code" modular framework for managing Kubernetes, built with Terraform and Helm.

## Motivation

Using many command line tools to manage cloud resources (e.g. `gcloud`, `aws`, `kops`) and Kubernetes resources (e.g. `kubectl`, `helm`) is tedious and error-prone.

Terraform already provides a declarative interface for a large number of cloud providers, so why not use Terraform to manage both cloud resources and containers through a single, fully automated interface?

## Sample workflow

1. **Initial setup**: Create an empty project for your deployment environment on a cloud platform like Amazon Web Services (AWS) or Google Cloud Platform (GCP) and get credentials for it. This is only done once for every deployment environment.

    [Tutorial for Google Cloud Platform](/setup/gcp-gke/)

2. **Edit code**: Configure your deployment environment by editing Terraform (HCL) files in your text editor of choice.

    [Guide to Exekube directory structure and framework usage](/) ● [Example directory structure](https://github.com/ilyasotkov/exekube/tree/develop/live/prod)

3. **Create an environment**: Run `xk apply` to deploy everything onto the cloud platform, including cloud infrastructure and Kubernetes resources.
4. **Update an environment**: Edit Terraform code in face of changing requirements and run `xk apply` again to match the state of your code to the state of real-world resources.
5. **Destroy an environment**: Run `xk destroy` to clean everything up.

This workflow is an excellent fit for creating simple continuous integration pipelines.

## Features

Exekube offers you:

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
