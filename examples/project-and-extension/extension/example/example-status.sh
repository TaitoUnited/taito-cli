#!/bin/bash -e

echo "- env: ${taito_env}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
