# CircleCI 2.0 Pipeline for deploying whole cloud environments

This is a simple pipeline that uses the `ilyasotkov/exekube:latest` from DockerHub.

We add secret credentials as base64-encoded environmental variables via the CircleCI web UI, then, in the pipeline, decode and save them to files, and finally run the equivalent of local `xk apply` and `xk destroy`.

## Known issues

### Only environment variables can be used for credentials

CircleCI only allows credentials to be added via environmental variables, and secret variables can only be added via the web UI.

### save_cache

Cache is CircleCI 2.0 is weird, with the official solution being nothing short of "hacky" or "dirty", with the problem stemming from

```yaml
- save_cache:
    key: all-cache
    paths:
      - /root/.helm
      - /root/.terragrunt
      - /root/.config/gcloud
      - /root/.kube
```

not being able to overwrite the previously existing cache. Read more about CircleCI 2.0 caching: <https://circleci.com/docs/2.0/caching/>
