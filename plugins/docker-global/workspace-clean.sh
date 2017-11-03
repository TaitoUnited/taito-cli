#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker-global - workspace-clean: Cleaning old images ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "docker system prune -a --filter 'label!=fi.taitounited.taito-cli'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
