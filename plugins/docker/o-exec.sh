#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### docker - exec: Executing ###"
echo

if ! "${taito_plugin_path}/util/exec.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
