#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

switch="${1}"
if [[ "${switch}" == "--all" ]]; then
  params=("${@:2}")
else
  params=("${@:1}")
fi

echo
echo "### kubectl - o-status: Showing status of ${taito_env} ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ "${switch}" == "--all" ]]; then
  switch=
  echo
  echo "--- Nodes ---"
  kubectl describe nodes
fi
echo
echo "--- Ingress ---"
kubectl get ingress "${params[@]}"
echo
echo
echo "--- Services ---"
kubectl get services "${params[@]}"
echo
echo
echo "--- Pods ---"
kubectl get pods "${params[@]}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
