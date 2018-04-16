#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
echo "TODO implement: confirm and then run 'ci deploy'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
