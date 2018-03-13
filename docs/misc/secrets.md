# Managing secrets

!!! warning
    This article is incomplete. Want to help? [Submit a pull request](https://github.com/exekube/exekube/pulls).

## Secrets directories

!!! info
    Tools for distributing secrets in a secure way are on the roadmap for 0.2.

Every directory in live (dev, stg, test, prod) should have a secrets subdirectory where you will store all secrets for the environment. Make sure to never commit any of the secrets to version control.

```diff
live
├── prod
│   ├── cluster
│   │   └── terraform.tfvars
│   ├── releases
│   │   ├── ...
+   └── secrets
+       ├── chartmuseum
+       │   ├── basic-auth-password
+       │   └── basic-auth-username
+       ├── ci
+       │   ├── apps-pipelines.yaml
+       │   ├── common.yaml
+       │   ├── forms-app-pipeline.yaml
+       │   └── rails-react-boilerplate.yaml
+       ├── concourse
+       │   ├── basic-auth-password
+       │   ├── basic-auth-username
+       │   ├── encryption-key
+       │   ├── github-auth-client-id
+       │   ├── github-auth-client-secret
+       │   ├── host-key
+       │   ├── host-key-pub
+       │   ├── old-encryption-key
+       │   ├── postgresql-user
+       │   ├── session-signing-key
+       │   ├── worker-key
+       │   └── worker-key-pub
+       ├── dashboard-rbac.yaml
+       ├── docker-registry
+       │   ├── basic-auth-password
+       │   └── basic-auth-username
+       ├── letsencrypt.yaml
+       └── sa
+           └── owner.json
├── stg
│   ├── cluster
│   │   └── terraform.tfvars
│   ├── releases
│   │   ├── ...
+   └── secrets
+       ├── chartmuseum
+       │   ├── basic-auth-password
+       │   └── ...
└── terraform.tfvars
```
