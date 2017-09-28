#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

switch="@{1}"

echo
echo "### kubectl - o-status: Showing status of ${taito_env} ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if [[ "${switch}" == "--all" ]]; then
  echo
  echo "--- Nodes ---"
  kubectl describe nodes
fi
echo
echo "--- Ingress ---"
kubectl get ingress "${@}"
echo
echo
echo "--- Services ---"
kubectl get services "${@}"
echo
echo
echo "--- Pods ---"
kubectl get pods "${@}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
