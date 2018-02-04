# Guide to configuring Exekube

## From your local workstation

| Type of config | Solution | Example / Explanation |
| --- | --- | --- |
| Framework tools config | `.env` file → docker-compose.yaml | Configuring tools like Terraform, Terragrunt, Kubernetes, e.g. `TF_VAR_gcp_project`. Example: [.env file](https://github.com/ilyasotkov/exekube/blob/develop/.env.example) |
| *Live module* config | `.tfvars` files commited to VCS | Example: [concourse/inputs.tfvars](https://github.com/ilyasotkov/exekube/blob/develop/live/prod/kube/ci/concourse/inputs.tfvars) |
| General secrets (sensitive config) | `.env` file → docker-compose.yaml | `TF_VAR_cloudflare_auth` environmental variable |
| *Live module* secrets | `<module-dir>/secrets` directory with files | Local files, never in VCS |

## From a continuous integration pipeline

| Type of config | Solution | Example / Explanation |
| --- | --- | --- |
| Framework tools config | Environmental variables | Configuring tools like Terraform, Terragrunt, Kubernetes, e.g. `TF_VAR_gcp_project`. Example: [Concourse task params sample](https://github.com/ilyasotkov/exekube/blob/develop/.concourse/secrets/apps-secrets.yml.sample) |
| *Live module* config | `.tfvars` files commited to VCS | Example: [concourse/inputs.tfvars](https://github.com/ilyasotkov/exekube/blob/develop/live/prod/kube/ci/concourse/inputs.tfvars) |
| General secrets (sensitive config) | Environmental variables / credential manager | `TF_VAR_cloudflare_auth` environmental variable |
| *Live module* secrets | Environmental variables, extracted into files through base64 encoding | See [.concourse/scripts/deploy](https://github.com/ilyasotkov/exekube/blob/develop/.concourse/scripts/deploy) |
