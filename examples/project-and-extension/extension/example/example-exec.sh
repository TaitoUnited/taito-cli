#!/bin/bash -e

echo "- target: ${taito_target}"
echo "- env: ${taito_env}"
echo "- args: ${@}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
