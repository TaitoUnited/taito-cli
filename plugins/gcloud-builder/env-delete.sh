#!/bin/bash

: "${taito_cli_path:?}"

echo "TODO not implemented. Delete trigger manually."
echo "Press enter when done"
read -r && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
