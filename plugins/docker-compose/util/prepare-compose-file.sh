#!/bin/bash

# Prepares docker-compose.yaml and docker-nginx.conf by replacing
# local services. Prints filename of the new docker-compose.yaml
# that contains the modifications.

if [[ $docker_compose_local_services ]]; then
  cp docker-nginx.conf docker-nginx.conf.tmp > /dev/null
  cp docker-compose.yaml docker-compose.yaml.tmp > /dev/null
  sed -i "s/docker-nginx.conf:/docker-nginx.conf.tmp:/" docker-compose.yaml.tmp\
    > /dev/null

  for service in $docker_compose_local_services; do
    name="${service%:*}"
    port="${service##*:}"
    sed -i "/^  $name:\$/,/^$/d" docker-compose.yaml.tmp > /dev/null
    sed -i "s/$name:.*;/host.docker.internal:$port;/" docker-nginx.conf.tmp \
      > /dev/null
  done
  echo docker-compose.yaml.tmp
else
  echo docker-compose.yaml
fi
