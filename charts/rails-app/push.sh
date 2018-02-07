#! /bin/bash

curl -u $CHARTMUSEUM_USERNAME:$CHARTMUSEUM_PASSWORD \
        --data-binary "@rails-app-0.1.0.tgz" \
        $CHARTMUSEUM_URL/api/charts
