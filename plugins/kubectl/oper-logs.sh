#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"
container_name="${2}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ ${pod} != *"-"* ]]; then
  pod=$(kubectl get pods | grep "${taito_project}" | grep "${pod}" | \
    head -n1 | awk '{print $1;}')
fi

if [[ -z "${container_name}" ]]; then
  container_name=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi

echo "${pod}"
echo "${container_name}"

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
  if ! (${taito_setv:?}; kubectl logs -f --tail=400 "${pod}" "${container_name}"); then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
