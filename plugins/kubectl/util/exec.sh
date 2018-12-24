#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

. "${taito_plugin_path}/util/determine-pod-container.sh"

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  (${taito_setv:?}; kubectl get pods)
else
  # Kubernetes
  (${taito_setv:?}; kubectl exec -it "${pod}" -c "${container}" -- "${@}")
fi
