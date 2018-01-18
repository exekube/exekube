# Rails app live module example

<https://github.com/ilyasotkov/exekube/tree/feature/vault/live/prod/kube/apps/rails-app>

Here is a quick example of how you'd configure a Rails application Helm release using Exekube (this is a part of a of a ["live" Terraform module](/), expressed in HashiCorp Configuration Language (HCL):

```sh
cd live/prod/kube/apps/rails-app/
tree .
.
├── inputs.tfvars
├── terraform.tfvars
└── values.yaml
```

```tf
# cat inputs.tfvars

release_spec = {
  enabled        = true
  domain_name    = "rails-app.swarm.pw"

  release_name   = "rails-app"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "rails-app"
  chart_version = "0.1.1"
}
```

```tf
# cat terraform.tfvars

terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-project",
      "../../core/ingress-controller",
      "../../core/kube-lego",
      "../../ci/chartmuseum",
      "../../ci/docker-registry",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
```

```yaml
# cat values.yaml

replicaCount: 2
image:
  repository: registry.swarm.pw/rails-react-boilerplate
  tag: "0.1.3"
  pullPolicy: Always
  pullSecret: registry-dockercfg
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
