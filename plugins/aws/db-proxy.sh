#!/bin/bash
: "${taito_cli_path:?}"
: "${database_name:?}"

echo "host=0.0.0.0, port=TODO"
echo "Connect using your personal user account or"
echo "${database_name} as username"

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
