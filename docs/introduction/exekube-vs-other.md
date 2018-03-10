# Compare Exekube to other software

!!! warning
    This article is incomplete. Want to help? [Submit a pull request](https://github.com/ilyasotkov/exekube/pulls).

## vs CLI tools / shell scripts

### CLI tools / Exekube legacy imperative workflow

Command line tools `kubectl` and `helm` are known to those who are familiar with Kubernetes. `gcloud` (part of Google Cloud SDK) is used for managing the Google Cloud Platform.

- `gcloud <group> <command> <arguments> <flags>`
- `kubectl <group> <command> <arguments> <flags>`
- `helm <command> <arguments> <flags>`

Examples:

```sh
gcloud auth list

kubectl get nodes

helm install --name custom-rails-app \
        -f live/prod/kube/apps/my-app/values.yaml \
        charts/rails-app
```

### Declarative workflow

- `xk up`
- `xk down`

Declarative tools are exact equivalents of stadard CLI tools like `gcloud` / `aws`, `kubectl`, and `helm`, except everything is implemented as a [Terraform provider plugin](/) and expressed as declarative HCL (HashiCorp Configuration Language) code.
