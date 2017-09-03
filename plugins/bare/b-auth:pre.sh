#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "### bare - b-auth:pre: Authenticating ###"
echo

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
