#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"
echo "TODO implement: build, push and deploy single container"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
