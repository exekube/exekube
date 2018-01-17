#!/bin/bash
domain_zone="swarm.pw"
source=("ci.${domain_zone}-tls" "wp.${domain_zone}-tls" "react.${domain_zone}-tls" "registry.${domain_zone}-tls" "charts.${domain_zone}-tls")

for i in ${source[@]}
do
  echo "---" >> /exekube/backup/tls/secret.yaml \
  && kubectl get secret $i -o yaml >> /exekube/backup/tls/secret.yaml
done
