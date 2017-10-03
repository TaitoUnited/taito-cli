#!/bin/bash
: "${taito_cli_path:?}"

echo
echo "### bare - --auth:pre: Authenticating ###"

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
