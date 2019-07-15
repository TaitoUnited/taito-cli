#!/bin/bash

if [[ ${taito_target_env:-} == "local" ]]; then
  echo "No database proxy required. Just connect with the following details:"
  "${taito_util_path}/display-db-proxy-details.sh"
  echo
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
