#!/bin/bash

: "${taito_cli_path:?}"

npm install && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
