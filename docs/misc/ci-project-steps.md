Each environment consists of a number of configured Terraform modules, each with its unique `terraform.tfvars` file:

```sh
# live/dev
.
├── project
│   └── terraform.tfvars
├── kubernetes
│   ├── cluster
│   │   └── terraform.tfvars
│   ├── default
│   │   ├── _helm
│   │   │   └── terraform.tfvars
│   │   ├── chartmuseum
│   │   │   ├── terraform.tfvars
│   │   │   └── values.yaml
│   │   ├── concourse
│   │   │   ├── terraform.tfvars
│   │   │   └── values.yaml
│   │   └── docker-registry
│   │       ├── terraform.tfvars
│   │       └── values.yaml
│   └── kube-system
│       ├── _helm
│       │   └── terraform.tfvars
│       ├── cluster-admin
│       │   ├── terraform.tfvars
│       │   └── values.yaml
│       ├── ingress-controller
│       │   ├── terraform.tfvars
│       │   └── values.yaml
│       └── kube-lego
│           ├── terraform.tfvars
│           └── values.yaml
...
```

But first, we will configure variables that will be used by multiple Terraform modules.

### Shared variables

We can share variables between multiple modules by setting shell variables starting with `TF_VAR_`:

```sh hl_lines="5"
# live/dev/.env

# TF_VAR_project_id is used to create a GCP project for our environment
# It's then used by modules to create resources for the environment
TF_VAR_project_id=dev-demo-ci-296e23 # MODIFY!!!

# TF_VAR_serviceaccount_key will be used to put the service account key
#   upon the creation of the GCP project
# It will then be used by modules to authenticate to GCP
TF_VAR_serviceaccount_key=/project/live/dev/secrets/kube-system/owner.json

# TF_VAR is the default directory for Terraform / Terragrunt
# Used when we run `xk up` or `xk down` without an argument
TF_VAR_default_dir=/project/live/dev/kubernetes

# TF_VAR_secrets_dir is used by multiple modules to source secrets from
TF_VAR_secrets_dir=/project/live/dev/secrets

# Keyring is used by the gcp-kms-secret-mgmt module
# Also by secrets-fetch and secrets-push scripts
# The GCP KMS keyring name to use
TF_VAR_keyring_name=keyring
```

To get started with the demo project, you will only need to modify the highlighted line to set a unique ID for your GCP project.

### Module-specific variables

The demo-ci-project consists of these modules (all are Exekube built-in modules).

- gcp-project
- gke-cluster
- helm-initializer (_helm)
    - kube-system namespace
    - default namespace
- helm-release
    - cluster-admin
    - ingress-controller
    - kube-lego
    - concourse
    - docker-registry
    - chartmuseum

Below we highlighted some variables we want to set to make sure everything is functional:

1. In [live/dev/project/terraform.tfvars](/), set `dns_zones` and `dns_records` variables. These will automatically point to the static regional IP address that we create for our ingress-controller.
2. In [live/dev/kubernetes/kube-system/cluster-admin/values.yaml](/), make sure `projectAdmins` variable has `projectowner@<YOUR-PROJECT-id>.iam.gserviceaccount.com` in it.
3. In [live/dev/kubernetes/kube-system/ingress-controller/values.yaml](/), make sure the variable `service.loadBalancerIP` is set to the static IP address we'll get as an output from `gcp-project` module.
4. In [live/dev/kubernetes/default/concourse/terraform.tfvars](/) set the `release_spec.domain_name` to a domain name from the `dns_records` variable in step 1.
5. Create a Kubernetes secret for Concourse and put into live/dev/secrets/default/concourse/secrets.yaml. Read the stable/concourse instructions about how to create the secret. If you will use GitHub OAuth for authenticating to Concourse, set that up as well.
6. Create basic-auth-username and basic-auth-password files for use with docker-registry and chartmuseum releases.
