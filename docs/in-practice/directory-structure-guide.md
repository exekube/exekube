# Project directory structure

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
