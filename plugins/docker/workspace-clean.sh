#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - workspace-clean: Cleaning old images ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro --entrypoint /docker-gc/docker-gc taito"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
