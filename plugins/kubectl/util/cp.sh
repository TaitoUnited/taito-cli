#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

source="${1:?}"
dest="${2:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

# Convert source pod name to full form
if [[ ${source} == *":"* ]]; then
  source_pod=$(kubectl get pods | grep "${taito_project}" | grep "${source%:*}" | \
    head -n1 | awk '{print $1;}')
  source_path="${source##*:}"
  source="${source_pod}:${source_path}"
  pod="${source_pod}"
fi

# Convert destination pod name to full form
if [[ ${dest} == *":"* ]]; then
  dest_pod=$(kubectl get pods | grep "${taito_project}" | grep "${dest%:*}" | \
    head -n1 | awk '{print $1;}')
  dest_path="${dest##*:}"
  dest="${dest_pod}:${dest_path}"
  pod="${dest_pod}"
fi

# Determine container name from pod name
container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')

kubectl cp "${source}" "${dest}" -c "${container}"
