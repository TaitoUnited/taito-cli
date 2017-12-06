#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project_path:?}"

echo "Showing secrets from docker-compose.yaml:"
cat docker-compose.yaml | grep -i "SECRET\|PASSWORD" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
