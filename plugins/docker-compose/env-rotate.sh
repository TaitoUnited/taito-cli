#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-secrets" "" \
  "Save newly created secrets to ./secrets"
then
  "${taito_plugin_path}/util/save-secrets.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
