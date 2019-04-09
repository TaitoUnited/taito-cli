#!/bin/bash

: "${taito_cli_path:?}"

filter=${1}

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
