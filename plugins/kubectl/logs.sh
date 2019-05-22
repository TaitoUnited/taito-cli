#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

container="${1}"

"${taito_plugin_path}/util/use-context.sh"

. "${taito_plugin_path}/util/determine-pod-container.sh"

echo pod: "${pod}"
echo container: "${container}"

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  echo
  (${taito_setv:?}; kubectl get pods)
else
  # Kubernetes
  echo
  echo "--- kubectl: Desciption ---"
  (${taito_setv:?}; kubectl describe pod "${pod}")
  echo
  echo
  echo "--- kubectl: Logs ---"
  if ! (${taito_setv:?}; kubectl logs -f --tail=400 "${pod}" "${container}"); then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
