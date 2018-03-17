#!/bin/bash

set -eu

gcloud projects get-iam-policy ${project_id} > /tmp/${project_id}.iam.policy.yml

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

gcloud projects set-iam-policy ${project_id} /tmp/${project_id}.iam.policy.yml
