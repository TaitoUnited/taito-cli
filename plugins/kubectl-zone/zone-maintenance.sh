#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "kubectl" "${name}" \
  "Rotate secrets"
then
  echo "TODO rotate secrets"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
