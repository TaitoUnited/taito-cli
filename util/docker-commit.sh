#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_image_name:?}"

# Asks host to commit changes to the container image

if [[ -z "${taito_admin_key:-}" ]] || [[ "${taito_is_admin:-}" == true ]]; then
  sleep 1
  "${taito_cli_path}/util/execute-on-host.sh" \
    "docker ps; docker commit ${HOSTNAME} ${taito_image_name}save"
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker image tag ${taito_image_name}save ${taito_image_name}"
  sleep 4
  echo
else
  echo "ERROR: Docker commit is not allowed when executing as admin!"
  exit 1
fi
