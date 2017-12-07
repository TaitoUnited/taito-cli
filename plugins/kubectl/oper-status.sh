#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

switch="${1}"
if [[ "${switch}" == "--all" ]]; then
  params=("${@:2}")
else
  params=("${@:1}")
fi

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ "${switch}" == "--all" ]]; then
  echo "--- Node details ---"
  kubectl describe nodes
  echo
  echo

  echo "--- Nodes ---"
  kubectl top nodes
  echo
  echo

  echo "--- Helm ---"
  helm list --namespace "${taito_namespace}"
  echo
  echo

  echo "--- Ingress ---"
  kubectl get ingress "${params[@]}"
  echo
  echo

  echo "--- Services ---"
  kubectl get services "${params[@]}"
  echo
  echo
fi

echo "--- Pods ---"
kubectl get pods "${params[@]}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
