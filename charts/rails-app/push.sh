#! /bin/bash

curl \
        -u $(echo $CHARTMUSEUM_USERNAME | base64 -d):$(echo $CHARTMUSEUM_PASSWORD | base64 -d) \
        --data-binary "@rails-app-1.0.0.tgz" \
        $(echo $CHARTMUSEUM_URL | base64 -d)/api/charts
