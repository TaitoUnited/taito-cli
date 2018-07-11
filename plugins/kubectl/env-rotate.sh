#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

name_filter="${1}"

if "${taito_cli_path}/util/confirm-execution.sh" "postgres" "" "Save secrets to Kubernetes"
then
  # Ensure that namespace exists
  "${taito_plugin_path}/util/use-context.sh"
  (${taito_setv:?}; kubectl create namespace "${taito_namespace}" 2> /dev/null)

  "${taito_plugin_path}/util/use-context.sh" && \
  "${taito_plugin_path}/util/save-secrets.sh" "${name_filter}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
