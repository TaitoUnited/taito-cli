#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-kubectl" "${name}" \
    "Execute Kubernetes cluster maintenance"
  then
      echo "TODO confirm and upgrade Kubernetes master"
      echo "TODO confirm and upgrade Kubernetes nodes"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
