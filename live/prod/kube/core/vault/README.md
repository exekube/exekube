# Vault Helm release

# Test connection

```sh
xk curl https://<master-ip>/api/v1/namespaces/default/services/vault-vault:8200/sys/seal-status/
```

```sh
xk kubectl port-forward <vault-pod-name> 443:8200

docker exec <local-container-id> curl -k -vv https://localhost/v1/sys/seal-status/

docker exec <local-container-id> curl --request PUT -s -k --data @payload.json https://localhost/v1/sys/init
```
