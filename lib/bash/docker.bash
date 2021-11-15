#!/bin/bash

function taito::commit_changes () {
  if [[ $RUNNING_TESTS == true ]]; then
    exit 0
  fi

  echo "Please wait..."
  sleep 1
  taito::execute_on_host \
    "docker commit ${HOSTNAME} ${taito_image_name}save"
  taito::execute_on_host_fg \
    "sleep 5 && docker image tag ${taito_image_name}save ${taito_image_name} && echo && echo Taito CLI changes tagged OK"
  sleep 5
  echo
  echo "Taito CLI changes committed OK"
}
export -f taito::commit_changes
