#!/bin/bash
domain_zone="swarm.pw"
source=("drone.${domain_zone}-tls" "ci.${domain_zone}-tls" "wp.${domain_zone}-tls" "react.${domain_zone}-tls" "registry.${domain_zone}-tls" "charts.${domain_zone}-tls")

for i in ${source[@]}
do
  echo "---" >> tls/secret.yaml \
  && docker-compose run --rm exekube kubectl get secret $i -o yaml >> tls/secret.yaml
done
