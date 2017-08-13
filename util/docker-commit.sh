#!/bin/bash
: "${taito_cli_path:?}"

# Asks host to commit changes to the container image

echo "TODO more checks so that only the correct container is committed"
# ${taito_cli_path}/util/execute-on-host.sh "container_id=$(docker ps | grep 'taito ' | cut -d ' ' -f1); docker commit \${container_id} ${taito_image_name}" 1

${taito_cli_path}/util/execute-on-host.sh "docker commit ${HOSTNAME} ${taito_image_name}" 1
