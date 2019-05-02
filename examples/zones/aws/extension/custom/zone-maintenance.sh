#!/bin/bash
: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "custom" "${name}" \
  "Execute custom maintenance"
then
  echo "extension/custom: doing some maintenance..."
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
