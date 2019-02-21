#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-save-secrets" "${name}" \
  "Save secrets to Kubernetes"
then
  # Make sure that namespace exists
  "${taito_plugin_path}/util/use-context.sh"
  "${taito_plugin_path}/util/ensure-namespace.sh" "${taito_namespace}"

  export kubectl_skip_restart="true";
  "${taito_plugin_path}/util/use-context.sh" && \
  "${taito_plugin_path}/util/save-secrets.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
