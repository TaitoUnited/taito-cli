#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

pod="${1:?}"
container="${2}"
command=("${@:3}")

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ "${container}" == "--" ]] || [[ "${container}" == "-" ]]; then
  container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  echo
  kubectl get pods
else
  # Kubernetes
  kubectl exec -it "${pod}" -c "${container}" -- "${command[@]}"
fi
