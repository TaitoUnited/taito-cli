#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

# Initialize Helm
if "${taito_cli_path}/util/confirm-execution.sh" "helm" "${name}"; then
  helm list
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
