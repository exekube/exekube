# Add audit config

```sh
gcloud projects get-iam-policy ${project_id} > ${project_id}.iam.policy.yml
```
```sh
cat <<EOT >> /tmp/${project_id}.iam.policy.yml
auditConfigs:
- auditLogConfigs:
  - logType: DATA_WRITE
  - logType: DATA_READ
  service: storage.googleapis.com
- auditLogConfigs:
  - logType: DATA_WRITE
  - logType: DATA_READ
  service: cloudkms.googleapis.com
EOT
```
```sh
gcloud projects set-iam-policy ${project_id} ${project_id}.iam.policy.yml
```
