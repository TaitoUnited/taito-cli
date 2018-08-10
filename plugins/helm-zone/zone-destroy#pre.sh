#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

# Delete Helm charts
if [[ -d "./helm" ]]; then
  charts=($(cd helm && ls)) && \
  for chart in ${charts[@]}
  do
    if "${taito_cli_path}/util/confirm-execution.sh" "${chart}" "${name}" \
      "Delete helm chart ${chart} from Kubernetes"
    then
      echo "- Deleting chart ${chart} using Helm"
      (
        ${taito_setv}
        helm delete "${chart}" --purge
      )
    fi
  done
fi

# TODO uninstall helm tiller?

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
