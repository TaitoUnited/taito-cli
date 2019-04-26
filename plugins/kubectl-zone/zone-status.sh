#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl" "${name}" \
  "Show Kubernetes status"
then
  echo
  echo
  echo --- Cluster ---
  kubectl get componentstatus
  echo
  echo
  echo --- Nodes ---
  kubectl describe nodes
  echo
  echo
  echo --- Top nodes ---
  kubectl top nodes
  echo
  echo
  echo --- Ingresses ---
  kubectl get ingress --all-namespaces
  echo
  echo
  echo --- Services ---
  kubectl get services --all-namespaces
  echo
  echo
  echo --- Pods ---
  kubectl get pods --all-namespaces
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
