#!/bin/bash

curl -u ${TF_VAR_chartmuseum_username}:${TF_VAR_chartmuseum_password} \
        --data-binary "@rails-app-0.1.0.tgz" \
        https://${TF_VAR_chartmuseum_domain_name}/api/charts
