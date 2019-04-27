#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "aws-auth" "${name}" \
    "Authenticate to Kubernetes ${kubectl_name:-}"
  then
    echo "Authenticating..."
    "${taito_cli_path}/plugins/aws/util/get-credentials-kube.sh" && \
    "${taito_cli_path}/util/docker-commit.sh"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
