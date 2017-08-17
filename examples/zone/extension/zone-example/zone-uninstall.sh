#!/bin/bash

: "${taito_cli_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "${name}" "zone-example"; then
  echo
  echo "### example - zone-uninstall: Uninstall example ###"
  echo
  echo "Uninstalling..."
  echo "DONE!"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
