#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### fission - ci-revert: Reverting ###"

revision="${1:-0}"

# TODO serverless.com support for fission?
echo "TODO revert fission function" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
