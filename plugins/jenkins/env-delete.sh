#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### jenkins - env-delete: Deleting a build trigger ###"

echo "TODO delete jenkins trigger" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
