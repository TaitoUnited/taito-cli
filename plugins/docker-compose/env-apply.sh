#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_env:?}"

name=${1}

export docker_compose_skip_restart="true"

if "${taito_util_path}/confirm-execution.sh" "docker-save-secrets" "${name}" \
  "Save secrets to ./secrets/${taito_env}"
then
  "${taito_plugin_path}/util/save-secrets.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
