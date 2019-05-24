#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_util_path}/confirm-execution.sh" "aws-auth" "${name}" \
    "Authenticate to Kubernetes ${kubernetes_name:-}"
  then
    echo "Authenticating"
    "${taito_cli_path}/plugins/aws/util/get-credentials-kube.sh" && \
    "${taito_util_path}/docker-commit.sh"
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
