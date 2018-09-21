#!/usr/bin/env bash

cprefix="${1:-*}"

envs="local ${taito_environments:-}"
for env in ${envs}; do
  env_suffix=":${env}"
  env_suffix="${env_suffix/:local/}"

  echo "example status${env_suffix}"

  for target in ${taito_targets}; do
    echo "example exec:${target}${env_suffix} COMMAND"
    echo "example shell:${target}${env_suffix}"
  done
done