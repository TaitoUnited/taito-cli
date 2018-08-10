#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "helm" "${name}" \
  "Show Helm status"
then
  helm list
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
