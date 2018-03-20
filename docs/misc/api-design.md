# Exekube API design review

## Initial setup (Terraform project)

- `TF_VAR_terraform_project`
- `TF_VAR_terraform_credentials`
- `TF_VAR_terraform_remote_state`

## Common product variables

- `TF_VAR_product_name`
- `TF_VAR_organization_id`
- `TF_VAR_billing_id`

## Specific project (product environment variables)

### In .env file

- `TF_VAR_xk_live_dir`
- `TF_VAR_secrets_dir`
- `PROJECT_ID`

### In project tfvars

```tf
product_env = "prod"

dns_zones = {
  "flexeption-pw" = "flexeption.pw."
  "flexeption-us" = "flexeption.us."
}

ingress_domains = {
  "flexeption-pw" = "*.flexeption.pw."
  "flexeption-us" = "*.flexeption.us."
}
```

### In secrets tfvars

```tf
product_env = "prod"

project_id = "prod-internal-ops-0aea2b77"

keyring_admins = [
  "user:ilya@sotkov.com",
]

keyring_users = []

crypto_keys = {
  "team1" = "user:ilya@sotkov.com"
  "team2" = "user:ilya@sotkov.com"
}
```

### In resources/cluster tfvars

```tf
project_id = "prod-internal-ops-0aea2b77"
network_name = "prod-internal-ops-network"
```

### Common for resources/releases/*

- `TF_VAR_secrets_dir`
