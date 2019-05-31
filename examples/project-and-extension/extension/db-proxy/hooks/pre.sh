#!/bin/bash -e

if [[ "${taito_command}" == "db-"* ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}db-proxy${H1e}"
  echo "Starting db proxy for ${database_name}"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
