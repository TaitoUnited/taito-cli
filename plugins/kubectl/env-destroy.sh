#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_namespace:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl-delete" "${name}"; then
  "${taito_plugin_path}/util/use-context.sh" && \

  echo "Deleting secrets from Kubernetes" && \
  "${taito_plugin_path}/util/delete-secrets.sh" && \

  echo "Delete namespace ${taito_namespace} (Y/n)?" && \
  echo "WARNING: Do not delete the namespace if it contains also some other apps" && \
  read -r confirm && \
  if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    (${taito_setv:?}; kubectl delete namespace "${taito_namespace}")
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
