# Vault Helm release

# Test connection

```sh
xk kubectl port-forward <vault-pod-name> 443:8200

docker exec <local-container-id> curl -k -vv https://localhost/v1/sys/seal-status/

# add payload.json to root repo to access via curl
# https://www.vaultproject.io/api/system/init.html
docker exec <local-container-id> curl --request PUT -s -k --data @payload.json https://localhost/v1/sys/init
```

```sh
vault init
```
