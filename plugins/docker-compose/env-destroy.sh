#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_namespace:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "docker-delete-secrets" "${name}" \
  "Delete secrets of from ./secrets/${taito_env}"
then
  "${taito_plugin_path}/util/delete-secrets.sh"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
