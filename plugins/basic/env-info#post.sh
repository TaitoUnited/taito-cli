#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"

echo "Domain: ${taito_domain:-}"
echo "IP addresses:"
getent hosts "${taito_domain:-$taito_default_domain}" | awk '{ print $1 }'

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
