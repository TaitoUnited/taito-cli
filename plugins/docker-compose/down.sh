#!/bin/bash
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "docker-compose down -v" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"