# What is Exekube?

Exekube is a framework (a.k.a. platform) for managing the whole lifecycle of Kubernetes-based projects. Exekube takes the modular "Infrastructure as Code" approach to automate the management of both cloud infrastructure and Kubernetes resources using popular open-source tools, [Terraform](https://terraform.io) and [Helm](https://helm.sh).

## What can I do with it?

With Exekube, you can specify all *cloud provider resources* and *Kubernetes resources* as declarative code, then run:

```sh
xk up
```

and a few minutes later, you should have a running Kubernetes cluster with all of your applications running in it!

When you make changes to your code, you can update the state of the cluster by running `xk up` again. You can also update only a specific part (module or directory of modules) by running `xk up <path/to/dir/with/modules>`. When you are done with the cluster, you can run
```sh
xk down
```
to destroy the whole cluster or `xk down <path/to/dir/with/modules>` to destroy a part of it.

Exekube is a *very flexible platform* (think Rails, not WordPress) that uses Terraform modules for packaging cloud provider resources and Helm charts for packaging Kubernetes resources, which means your get all the control and extensibility while also enjoying full automation.

## Tools used in the framework

The framework is distributed as a [Docker image on Docker Hub](https://hub.docker.com/r/exekube/exekube/) that can be used manually by DevOps engineers or automatically via continuous integration (CI) pipelines, and heavily relies on these tools:

| Component | Version | Role |
| --- | --- | --- |
| Docker / Docker Compose | 17.06+ | Local (workstation) container runtime / orchestrator |
| Terraform | 0.11.7 | Declarative cloud infrastructure and automation manager |
| Terragrunt | 0.14.8 | Terraform *live module* manager |
| Kubernetes | 1.9.6 | Container orchestrator |
| Helm | 2.8.2 | Kubernetes package (chart / release) manager |

You can learn more about Exekube's architecture here: https://docs.exekube.com/intro/architecture

## Infrastructure as Code

One of the main ideas of this framework is to describe as much as possible of our cloud provider (e.g. AWS, GCP, Azure) configuration and Kubernetes configuration as files stored in version control (e.g. Git).

Since almost any project will be tested in non-production envrionments (e.g. dev, test, stg, qa) before production, we want to reuse code as much as possible (and keep it DRY). For that purpose, we package most of the code into Terraform modules or Helm charts.

## Examples

Head to one of the demo project's GitHub to see what a project managed with Exekube looks like:

- [base-project](https://github.com/exekube/base-project): A minimal Exekube project on Google Cloud Platform / GKE
- [demo-apps-project](https://github.com/exekube/demo-grpc-project): Deploy web applications (Ruby on Rails, React) onto Google Cloud Platform / GKE
- [demo-ci-project](https://github.com/exekube/demo-ci-project): Deploy private CI tools (Concourse, Docker Registry, ChartMuseum) onto Google Cloud Platform / GKE
- [demo-grpc-project](https://github.com/exekube/demo-grpc-project): Deploy a hello-world gRPC server app and its REST client app onto Google Cloud Platform / GKE
- [demo-istio-project](https://github.com/exekube/demo-istio-project): Get started with the Istio mesh framework on GKE

## Get started with Exekube

To get started with Exekube, follow the link to the *Getting Started Tutorial*:

**[→ Tutorial: Getting started with Exekube](/in-practice/getting-started)**

👋 See you there!
