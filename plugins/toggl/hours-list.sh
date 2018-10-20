#!/bin/bash -e
: "${taito_util_path:?}"

echo "TODO implement with javascript or python instead? (json handling)"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
