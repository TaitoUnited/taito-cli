#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_image_name:?}"

# Asks host to commit changes to the container image

sleep 1
# ${taito_cli_path}/util/execute-on-host.sh \
#   "docker ps; docker commit ${HOSTNAME} ${taito_image_name}" 5
"${taito_cli_path}/util/execute-on-host.sh" \
  "docker ps; docker commit taito ${taito_image_name}save" 5
"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "docker image tag ${taito_image_name}save ${taito_image_name}"
