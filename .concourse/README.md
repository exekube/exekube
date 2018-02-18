# Concourse Pipelines

## Log in

```sh
fly -t ci login -c https://ci.swarm.pw
```

## Set pipelines via Fly CLI


### hello-pipeline

```sh
fly --target ci set-pipeline --pipeline hello-pipeline --config .concourse/hello-pipeline.yml
```

### rails-react-boilerplate-pipeline

```sh
fly --target ci set-pipeline --pipeline rails-react-boilerplate-pipeline --config .concourse/rails-react-boilerplate.yml --load-vars-from .concourse/secrets/rails-react-boilerplate.yml
```

### helm-release-pipeline

```sh
fly --target ci set-pipeline --pipeline helm-release-pipeline --config .concourse/helm-release.yml --load-vars-from .concourse/secrets/helm-release.yml
```

### apps-pipeline

```sh
fly --target ci set-pipeline --pipeline apps-pipeline --config .concourse/apps-pipeline.yml --load-vars-from .concourse/secrets/apps-secrets.yml
```
