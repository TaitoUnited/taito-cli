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
echo "### kubectl - oper-status: Showing status of ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ "${switch}" == "--all" ]]; then
  switch=
  echo "--- Node details ---"
  kubectl describe nodes
  echo
  echo
fi

echo "--- Nodes ---"
kubectl top nodes
echo
echo

if [[ "${switch}" == "--all" ]]; then
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
