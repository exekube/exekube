#!/bin/bash
domain_zone="swarm.pw"
source=("ci.${domain_zone}-tls" "wp.${domain_zone}-tls" "react.${domain_zone}-tls" "registry.${domain_zone}-tls" "charts.${domain_zone}-tls")
green="\e[1;32m"
no_color="\e[0m"
secret_file_name="secret-$(date '+%Y-%m-%d-%H-%M-%S').yaml"

for i in ${source[@]}
do
  echo "---" >> /exekube/backup/tls/${secret_file_name} \
  && kubectl get secret $i -o yaml >> /exekube/backup/tls/${secret_file_name} \
  && printf "${green}Secret '${i}' has been saved to ./backup/tls/${secret_file_name} successfully!\n${no_color}"
done
