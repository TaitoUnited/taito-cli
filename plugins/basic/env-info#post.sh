#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

echo "Domain: ${taito_domain:-}"
echo "IP addresses:"
getent hosts "${taito_domain:-$taito_default_domain}" | awk '{ print $1 }'

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
