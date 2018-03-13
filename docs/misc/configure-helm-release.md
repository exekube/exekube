# Ruby on Rails app example

<https://github.com/ilyasotkov/exekube/tree/feature/vault/live/prod/kube/apps/rails-app>

Here is a quick example of how you'd deploy a Rails application by configuring the Exekube built-in [helm-release](/reference/helm-release) module:

```sh
# live/prod/releases/rails-app
tree .
.
├── terraform.tfvars
└── values.yaml
```

```tf
# cat terraform.tfvars

# Module metadata

terragrunt = {
  terraform {
    source = "/exekube-modules//helm-release"
  }

  dependencies {
    paths = [
      "../../cluster",
      "../ingress-controller",
      "../kube-lego",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}

# Module configuration
# ---
# Module inputs and defaults:
# https://github.com/exekube/exekube/blob/develop/modules/helm-release/inputs.tf

release_spec = {
  enabled      = true
  release_name = "rails-app"

  chart_repo = "exekube"
  chart_name = "rails-app"
  chart_version  = "1.0.0"

  domain_name = "my-app.YOURDOMAIN.COM"
}
```

```yaml
# cat values.yaml

# Default values for ..
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
replicaCount: 2
# nameOverride: rails
image:
  repository: ilyasotkov/rails-react-boilerplate
  tag: 1.0.0
  pullPolicy: Always
  # pullSecret: registry-login-secret
ingress:
  # If true, an Ingress Resource will be created
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "nginx"
    kubernetes.io/tls-acme: "true"
  hosts:
    - ${domain_name}
  tls:
    - secretName: ${domain_name}-tls
      hosts:
        - ${domain_name}
```
