#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-save" "${name}"; then
  echo "Saving secrets to Kubernetes"

  # Make sure that namespace exists
  "${taito_plugin_path}/util/use-context.sh"
  (${taito_setv:?}; kubectl create namespace "${taito_namespace}" &> /dev/null)

  export kubectl_skip_restart="true";
  "${taito_plugin_path}/util/use-context.sh" && \
  "${taito_plugin_path}/util/save-secrets.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
