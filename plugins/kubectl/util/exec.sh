#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

pod="${1:?}"
container="${2}"
command=("${@:3}")

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ ${pod} != *"-"* ]]; then
  pod=$(kubectl get pods | grep server | head -n1 | awk '{print $1;}')
fi

if [[ "${container}" == "--" ]] || [[ "${container}" == "-" ]]; then
  container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi

if [[ -z "${pod}" ]]; then
  echo
  echo "kubectl: Please give pod name as argument:"
  kubectl get pods
else
  # Kubernetes
  echo
  echo "-------------------------------------------------------------------"
  echo
  kubectl exec -it "${pod}" -c "${container}" -- "${command[@]}"
fi
