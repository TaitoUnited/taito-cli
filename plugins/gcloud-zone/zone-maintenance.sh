#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-kubectl" "${name}"; then
  if [[ -n "${kubectl_name:-}" ]]; then
    echo "TODO upgrade Kubernetes master"
    echo "TODO upgrade Kubernetes nodes"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
