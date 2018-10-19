#!/bin/bash
: "${taito_cli_path:?}"

echo "${taito_environments/prod/master}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
