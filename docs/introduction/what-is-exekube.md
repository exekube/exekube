# What is Exekube?

Exekube is a framework (or platform, Platform-as-Code) for managing the whole lifecycle of Kubernetes-based projects. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools, [Terraform](https://terraform.io) and [Helm](https://helm.sh).

## Tools used in the framework

The framework is distributed as a [Docker image on Docker Hub](https://hub.docker.com/r/ilyasotkov/exekube/) that can be used manually by DevOps engineers or automatically via continuous integration (CI) pipelines. It combines several open-source DevOps tools into an automated workflow for managing both cloud infrastructure and Kubernetes resources:

| Component | Version | Role |
| --- | --- | --- |
| Docker | --- | Local and cloud container runtime |
| Docker Compose | --- | Local development enviroment manager |
| Terraform | 0.11.7 | Declarative cloud infrastructure and automation manager |
| Terragrunt | 0.14.7 | Terraform *live module* manager |
| Kubernetes | 1.9.6 | Container orchestrator |
| Helm | 2.8.2 | Kubernetes package (chart / release) manager |

## Infrastructure as Code

The main idea of this framework is to describe as much as possible of our cloud provider (e.g. AWS, GCP, Azure) configuration and Kubernetes configuration as files stored in version control (e.g. Git).

Since almost any project will be tested in non-production envrionments (e.g. dev, test, stg, qa) before production, we want to reuse code as much as possible (and keep it DRY). For that purpose, we package most of the code into Terraform modules or Helm charts.

## Examples

Head to one of the demo project's GitHub to *see what a project managed via Exekube* looks like:

- [demo-apps-project](https://github.com/exekube/demo-grpc-project): Deploy web applications (Ruby on Rails, React) onto Google Cloud Platform / GKE

- [demo-ci-project](https://github.com/exekube/demo-ci-project): Deploy private CI tools (Concourse, Docker Registry, ChartMuseum) onto Google Cloud Platform / GKE

- [demo-grpc-project](https://github.com/exekube/demo-grpc-project): Deploy a hello-world gRPC server app and its REST client app onto Google Cloud Platform / GKE

## Get started with Exekube

To get started with Exekube, follow the link to our tutorial:

**[→ Tutorial: Getting started with Exekube](/usage/deploy-app)**

👋 See you there!
