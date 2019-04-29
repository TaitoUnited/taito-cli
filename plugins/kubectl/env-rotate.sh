#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

export kubernetes_skip_restart="true"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-secrets" "" \
  "Save newly created secrets to Kubernetes"
then
  # Ensure that namespace exists
  "${taito_plugin_path}/util/use-context.sh"
  "${taito_plugin_path}/util/ensure-namespace.sh" "${taito_namespace}"

  "${taito_plugin_path}/util/use-context.sh"
  "${taito_plugin_path}/util/save-secrets.sh"
  export kubernetes_skip_restart="false"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
