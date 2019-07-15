#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_util_path}/confirm-execution.sh" "gcp-kubectl" "${name}" \
    "Execute Kubernetes cluster maintenance"
  then
      echo "TODO confirm and upgrade Kubernetes master"
      echo "TODO confirm and upgrade Kubernetes nodes"
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
