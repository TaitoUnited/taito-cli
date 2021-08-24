#!/bin/bash

function taito::commit_changes () {
  if [[ $RUNNING_TESTS == true ]]; then
    exit 0
  fi

  if [[ -z "${taito_admin_key:-}" ]] || [[ ${taito_is_admin:-} == true ]]; then
    echo "Please wait..."
    sleep 5
    taito::execute_on_host \
      "docker commit ${HOSTNAME} ${taito_image_name}save > /dev/null"
    sleep 5
    taito::execute_on_host_fg \
      "sleep 5 && docker image tag ${taito_image_name}save ${taito_image_name} && echo OK"
  else
    echo "ERROR: Docker commit is not allowed when executing as admin!"
    exit 1
  fi
}
export -f taito::commit_changes
