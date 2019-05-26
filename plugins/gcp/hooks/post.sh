#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_provider:-} == "gcp" ]] && \
   [[ ${gcp_db_proxy_enabled:-} != "false" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  echo
  echo -e "${H1s}gcp${H1e}"
  echo "Stopping all db proxies"
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
