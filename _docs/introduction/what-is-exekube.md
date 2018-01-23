# What is Exekube?

*Exekube* is a declarative "Infrastructure as Code" framework (a.k.a. platform / PaaS) for managing cloud infrastructure (notably Kubernetes clusters) and deploying containerized software onto that infrastructure.

## The declarative workflow

Right after you enable billing on a cloud platform like Amazon Web Services or Google Cloud Platform, you are able to run one command

```bash
xk apply
```

in order to:

- Create a Kubernetes cluster and supporting resources on the cloud platform
- Deploy any number of Kubernetes resources onto the cluster (as Helm releases)

When it's time to upgrade some of your cloud resources, just modify your code and run `xk apply` again. Terraform will match the state of your code to the state of your cloud resources.

To clean up, run `xk destroy` and the whole thing is gone from the cloud.

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
