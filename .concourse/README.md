# Concourse Pipelines

## Commons tasks

### Log in

```sh
fly -t ci login -c https://ci.swarm.pw
```

### Enable apps-pipeline

```sh
fly --target ci set-pipeline --pipeline apps-pipeline --config .concourse/apps-pipeline.yml --load-vars-from .concourse/secrets/apps-secrets.yml
```
