#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### fission - revert: Reverting ###"
echo
echo TODO

revision="${1}"
if [[ "${revision}" == "" ]]; then
  revision=0
fi

# TODO serverless.com support for fission?
echo "TODO revert fission function";

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
