#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${gcloud_project:?}"
: "${gcloud_zone:?}"
: "${database_name:?}"

port="${1}"

(
  if [[ "${port}" ]]; then
    export database_port="${port}"
    export database_proxy_port="${port}"
  fi

  echo "Database connection details:"
  echo "- host: 127.0.0.1"
  echo "- port: ${database_port:-}"
  echo "- database: ${database_name:-}"
  echo "- username: ${database_username:-}, ${database_name}, ${database_name}_app, ${database_name}ap or your personal username"
  echo "- password: ${database_password:-?}"

  "${taito_plugin_path}/util/db-proxy-start.sh" && \
  "${taito_plugin_path}/util/db-proxy-stop.sh"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
