#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_hours_description:?}"

echo "TODO implement. Use jq, python or node for json handling."
echo "Description: ${taito_hours_description}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
