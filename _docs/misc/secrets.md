# Managing secrets

## What are secrets?

*Secrets* are configuration values that are directly responsible for the security of a part of a DevOps system.

Examples:

- GitHub OAuth application token pair
- CloudFlare *email:token* pair
- Private Docker Registry *username:password* pair

Managing secrets is non-trivial.

## All secrets currently not commited to VCS

| Path | Purpose | Management strategy |
| --- | --- | --- |
| `credentials.json` | Authenticate to GCP project | Create via GUI, use by the `gcloud auth activate-service-account --key-file credentials.json`, delete ? |
| `.env` | Random TF_VAR_* variables | Commit to VCS if only use to import values `export TF_VAR_mysecret="$(security find-generic-password -a mysecret -w)"` |
| `backup/tls` | Store LE TLS certificates | Replace with Ark, encrypt in VCS |
| `config/**` | Auto-generated config files for gcloud, kubectl, helm, terraform | Never commit to VCS |
| `live/prod/kube/**/secrets/**` | Create Kubernetes Secrets via pre_hook (for now) | Replace with Vault? Store encrypted VCS? |
