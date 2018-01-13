#!/bin/bash
source=("jenkins-tls" "wp.swarm.pw-tls" "react.swarm.pw-tls" "docker-registry-tls" "chartmuseum-tls")
for i in ${source[@]}
do
  echo "---" >> tls/secret.yaml \
  && docker-compose run --rm exekube kubectl get secret $i -o yaml >> tls/secret.yaml
done
