# Concourse Pipeline

## Adding the pipeline from the `fly` CLI

```sh
fly -t ci login -c https://ci.swarm.pw
```

```sh
fly -t ci set-pipeline -p hello-world -c .concourse/pipeline.yml
```

## Terraform

**TODO:** Use Terraform instead of the `fly` CLI
