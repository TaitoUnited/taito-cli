#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

name=${1}

export docker_compose_skip_restart="true"

if "${taito_cli_path}/util/confirm-execution.sh" "docker-save-secrets" "${name}" \
  "Save secrets to ./secrets"
then
  "${taito_plugin_path}/util/save-secrets.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
