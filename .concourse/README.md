# Concourse Pipelines

## Commons tasks

### Log in

```sh
fly -t ci login -c https://ci.swarm.pw
```

### Enable hello-pipeline

```sh
fly -t ci set-pipeline -p hello-world -c .concourse/hello-pipeline.yml
```

### Enable apps-pipeline

```sh
fly --target ci set-pipeline --pipeline apps-pipeline --config .concourse/apps-pipeline.yml --load-vars-from .concourse/secrets/apps-secrets.yml
```

## Terraform intead of Fly CLI

**TODO:** Use terraform-provider-concourse instead of the Fly CLI when it becomes available
