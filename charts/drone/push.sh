#! /bin/bash

curl \
        -u $($CHARTMUSEUM_USERNAME | base64 -d):$($CHARTMUSEUM_PASSWORD | base64 -d) \
        --data-binary "@drone-0.3.0.tgz" \
        $CHARTMUSEUM_URL/api/charts
