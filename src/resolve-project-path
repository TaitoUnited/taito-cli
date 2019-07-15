#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

# Resolve project root folder by the location of taito-config.sh
current_path="${PWD}"
while [[ "${PWD}" != "/" ]]; do
  ls | grep taito-config.sh > /dev/null && break; cd ..;
done
if [[ ${PWD} != "/" ]]; then
  echo "${PWD}"
else
  echo "${current_path}"
fi
