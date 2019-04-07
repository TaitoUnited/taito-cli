#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_env:?}"

export docker_compose_skip_restart="true"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-secrets" "" \
  "Save newly created secrets to ./secrets/${taito_env}"
then
  "${taito_plugin_path}/util/save-secrets.sh"
  export docker_compose_skip_restart="false"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
