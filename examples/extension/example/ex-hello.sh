#!/bin/bash
: "${taito_util_path:?}"

echo "Hello world!"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
