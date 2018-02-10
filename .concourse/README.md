# Concourse Pipelines

## Commons tasks

### Log in

```sh
fly -t ci login -c https://ci.swarm.pw
```

### Demo: enable hello-pipeline

```sh
fly --target ci set-pipeline --pipeline hello-pipeline --config .concourse/hello-pipeline.yml
```

### Enable apps-pipeline

```sh
fly --target ci set-pipeline --pipeline apps-pipeline --config .concourse/apps-pipeline.yml --load-vars-from .concourse/secrets/apps-secrets.yml
```
