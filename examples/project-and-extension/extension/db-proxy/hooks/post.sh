#!/bin/bash -e

if [[ "${taito_command}" == "db-"* ]]; then
  echo
  echo "### db-proxy: Stopping db proxy for ${database_name}"
  echo
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
