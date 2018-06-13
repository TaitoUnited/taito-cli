#!/bin/bash
: "${taito_cli_path:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "jenkins-trigger" "${name}"; then
  echo "TODO delete build trigger"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
