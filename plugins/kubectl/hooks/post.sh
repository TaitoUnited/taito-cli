#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  echo
  echo "### kubectl/post: Stopping all db proxies"
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
