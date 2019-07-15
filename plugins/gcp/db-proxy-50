#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"

port="${1}"

(
  if [[ "${port}" ]]; then
    export database_port="${port}"
  fi

  echo "Database connection details:"
  "${taito_util_path}/display-db-proxy-details.sh"
  echo
  "${taito_plugin_path}/util/db-proxy-start.sh" && \
  "${taito_plugin_path}/util/db-proxy-stop.sh"
) && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
