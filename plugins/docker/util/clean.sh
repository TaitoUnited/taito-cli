#!/bin/bash
: "${taito_cli_path:?}"

# TODO [data | build] as arguments
echo "Docker will remove images and volumes after taito-cli has exited"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
"docker-compose down --rmi 'all' --volumes --remove-orphans"
