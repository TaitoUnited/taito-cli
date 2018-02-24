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
  (${taito_setv:?}; kubectl describe nodes)
  echo
  echo

  echo "--- Nodes ---"
  (${taito_setv:?}; kubectl top nodes)
  echo
  echo

  echo "--- Helm ---"
  (${taito_setv:?}; helm list --namespace "${taito_namespace}")
  echo
  echo

  echo "--- Ingress ---"
  (${taito_setv:?}; kubectl get ingress "${params[@]}")
  echo
  echo

  echo "--- Services ---"
  (${taito_setv:?}; kubectl get services "${params[@]}")
  echo
  echo
fi

echo "--- Pods ---"
(${taito_setv:?}; kubectl get pods "${params[@]}")

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
