#!/bin/bash

: "${taito_cli_path:?}"

# TODO open db proxy connection to machine?

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
