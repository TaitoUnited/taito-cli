#!/bin/bash
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "\
docker stop \$(docker ps -a -q); \
sleep 2; \
docker system prune -a --filter 'label!=fi.taitounited.taito-cli'"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
