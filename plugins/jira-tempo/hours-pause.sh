#!/bin/bash -e
: "${taito_util_path:?}"

echo "TODO implement. Use jq, python or node for json handling."

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"