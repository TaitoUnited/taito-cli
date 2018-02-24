#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
docker stop $(docker ps -a -q); \
docker system prune -a --filter 'label!=fi.taitounited.taito-cli'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
