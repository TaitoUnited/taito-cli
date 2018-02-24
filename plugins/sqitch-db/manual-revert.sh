#!/bin/bash
: "${taito_cli_path:?}"

echo "TODO implement: run 'db log' and 'db revert'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
