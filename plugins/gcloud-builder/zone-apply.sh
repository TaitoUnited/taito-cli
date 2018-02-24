#!/bin/bash
: "${taito_cli_path:?}"

echo "TODO implement: function that sends notifications on build fail"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
