#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
"docker kill \$(docker ps -q)" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
