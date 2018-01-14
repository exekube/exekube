#!/bin/bash
source=("drone.swarm.pw-tls" "ci.swarm.pw-tls" "wp.swarm.pw-tls" "react.swarm.pw-tls" "registry.swarm.pw-tls" "charts.swarm.pw-tls")
for i in ${source[@]}
do
  echo "---" >> tls/secret.yaml \
  && docker-compose run --rm exekube kubectl get secret $i -o yaml >> tls/secret.yaml
done
