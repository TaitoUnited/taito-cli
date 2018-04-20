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
  # TODO use determine-pod-container.sh
  source_pod=$(kubectl get pods | grep "${taito_project}" | \
    sed -e "s/${taito_project}-//" | \
    grep "${source%:*}" | \
    head -n1 | awk "{print \"${taito_project}-\" \$1;}")
  source_path="${source##*:}"
  source="${source_pod}:${source_path}"
  pod="${source_pod}"
fi

# Convert destination pod name to full form
if [[ ${dest} == *":"* ]]; then
  # TODO use determine-pod-container.sh
  dest_pod=$(kubectl get pods | grep "${taito_project}" | \
    sed -e "s/${taito_project}-//" | \
    grep "${dest%:*}" | \
    head -n1 | awk "{print \"${taito_project}-\" \$1;}")
  dest_path="${dest##*:}"
  dest="${dest_pod}:${dest_path}"
  pod="${dest_pod}"
fi

# Determine container name from pod name
container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')

(${taito_setv:?}; kubectl cp "${source}" "${dest}" -c "${container}")
