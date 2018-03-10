# React app live module example

<https://github.com/ilyasotkov/exekube/tree/feature/vault/live/prod/kube/apps/rails-app>

Here is a quick example of how you'd deploy a React application by configuring the Exekube built-in [helm-release](/reference/helm-release) module:

```sh
mkdir live/prod/releases/forms-app \
&& cd live/prod/releases/forms-app \
&& tree .
.
├── terraform.tfvars
└── values.yaml
```

```tf
# cat terraform.tfvars

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
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

release_spec = {
  enabled        = true
  domain_name    = "react.example.com"

  release_name   = "forms-app"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "nginx-react"
  chart_version = "0.1.0"
}
```

```yaml
# cat values.yaml

replicaCount: 2
image:
  repository: ilyasotkov/forms-app
  tag: "0.1.0"
  pullPolicy: Always
ingress:
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
postgresql:
  persistence:
    enabled: true
  postgresUser: postgres
  postgresPassword: postgres
```
