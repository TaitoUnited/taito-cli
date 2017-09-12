#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - workspace-clean: Cleaning old images ###"
echo "TODO more settings from https://github.com/spotify/docker-gc#manual-usage"

echo "TODO run on host instead of container -> install docker-gc on host?"
docker-gc && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
