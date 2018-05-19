#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project_path:?}"
: "${taito_setv:?}"

echo "Showing secrets from docker-compose.yaml:"
(${taito_setv}; cat docker-compose.yaml | grep -i "SECRET\|PASSWORD") && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"