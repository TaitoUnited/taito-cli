#!/bin/bash -e
: "${taito_util_path:?}"

echo "${taito_environments/prod/master}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
