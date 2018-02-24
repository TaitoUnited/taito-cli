#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

source="${1:?}"
dest="${2:?}"

# Convert source pod name to full form
if [[ ${source} == *":"* ]]; then
  . "${taito_plugin_path}/util/determine-pod.sh" "${source%:*}"
  source_pod="${pod}"
  source_path="${source##*:}"
  source="${source_pod}:${source_path}"
fi

# Convert destination pod name to full form
if [[ ${dest} == *":"* ]]; then
  . "${taito_plugin_path}/util/determine-pod.sh" "${dest%:*}"
  dest_pod="${pod}"
  dest_path="${dest##*:}"
  dest="${dest_pod}:${dest_path}"
fi

docker_cmd="docker cp ${source} ${dest}"
"${taito_cli_path}/util/execute-on-host-fg.sh" "${docker_cmd}"
