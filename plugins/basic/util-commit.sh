#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/docker-commit.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
