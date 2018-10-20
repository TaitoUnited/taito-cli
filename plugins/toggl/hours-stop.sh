#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_hours_description:?}"

echo "TODO implement with javascript or python instead? (json handling)"
echo "Description: ${taito_hours_description}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
