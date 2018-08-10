#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "custom" "${name}" \
  "Execute custom doctor"
then
  echo "extension/custom: doing some doctoring..."
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
