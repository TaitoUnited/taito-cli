#!/bin/bash
: "${taito_cli_path:?}"

echo "TODO implement: confirm and the run 'db deploy'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
