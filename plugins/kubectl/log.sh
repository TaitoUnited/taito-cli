#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

pod="${1}"
container_name="${2}"

echo
echo "### kubectl - log: Showing logs of ${pod} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ -z "${container_name}" ]]; then
  container_name=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  echo
  kubectl get pods
else
  # Kubernetes
  echo
  echo "--- kubectl: Desciption ---"
  kubectl describe pod "${pod}"
  echo
  echo
  echo "--- kubectl: Logs ---"
  if ! kubectl logs "${1}" "${container_name}"; then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
