FROM google/cloud-sdk:183.0.0-alpine

RUN apk add --no-cache \
        openssl \
        && gcloud components install kubectl \
        && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

COPY bin/terraform /usr/bin/terraform
