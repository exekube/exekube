# Compare deploying Helm releases via Helm CLI to using terraform-provider-helm

**Example**: deploy a Concourse Helm release onto an existing Kubernetes cluster

## Helm CLI

1. Push the locally-developed Helm chart to a remote chart repository (ChartMuseum) and update our local repository index:
```sh
cd charts/concourse \
        && bash push.sh \
        && helm repo update
```

2. Create the Kubernetes secrets necessary for the release:
```sh
kubectl create secret generic concourse-concourse \
        --from-file=live/prod/kube/ci/concourse/secrets/
```

3. Deploy the Helm release: pull the chart, combine with our release values and submit to the Kubernetes API:
```sh
helm install \
        --name concourse \
        -f values.yaml \
        private/concourse
```

4. Upgrade the release:
```sh
helm upgrade \
        -f values.yaml \
        concourse \
        private/concourse
```

5. Destroy the release:
```sh
helm delete \
        concourse \
        --purge
```

## terraform-provider-helm (via Exekube)

1. Import the `helm-release` Terraform module and declare its dependencies:
```tf
terragrunt = {
  terraform {
    source = "/exekube/modules//helm-release"
  }

  dependencies {
    paths = [
      "../../../infra/gcp-gke",
      "../../core/ingress-controller",
      "../../core/kube-lego",
      "../chartmuseum",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
```

2. Configure the release via the `helm-release` module API:
```tf
release_spec = {
  enabled        = true
  release_name   = "concourse"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "concourse"
  chart_version = "1.0.0"

  domain_name = "ci.swarm.pw"
}

pre_hook = {
  command = <<-EOF
            kubectl create secret generic concourse-concourse \
            --from-file=/exekube/live/prod/kube/ci/concourse/secrets/ || true \
            && cd /exekube/charts/concourse/ \
            && bash push.sh \
            && helm repo update
            EOF
}
```

3. Deploy or upgrade the release:
```sh
xk up live/prod/kube/ci/concourse
```

4. Destroy the release:
```sh
xk down live/prod/kube/ci/concourse
```
