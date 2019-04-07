#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_namespace:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "docker-delete-secrets" "${name}" \
  "Delete secrets of from ./secrets/${taito_env}"
then
  "${taito_plugin_path}/util/delete-secrets.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
