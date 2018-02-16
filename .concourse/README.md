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

```sh
fly --target ci set-pipeline --pipeline rails-react-boilerplate-pipeline --config .concourse/rails-react-boilerplate.yml --load-vars-from .concourse/secrets/rails-react-boilerplate.yml
```

```sh
fly --target ci set-pipeline --pipeline helm-release-pipeline --config .concourse/helm-release.yml --load-vars-from .concourse/secrets/helm-release.yml
```

### Enable apps-pipeline

```sh
fly --target ci set-pipeline --pipeline apps-pipeline --config .concourse/apps-pipeline.yml --load-vars-from .concourse/secrets/apps-secrets.yml
```
