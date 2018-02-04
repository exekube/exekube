# Concourse Pipeline

## Adding the pipeline from the Fly CLI

```sh
fly -t ci login -c https://ci.swarm.pw
```

```sh
fly -t ci set-pipeline -p hello-world -c .concourse/pipeline.yml
```

## Terraform

**TODO:** Use terraform-provider-concourse instead of the Fly CLI when it becomes available
