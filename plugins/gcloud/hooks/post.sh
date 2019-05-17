#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_provider:-} == "gcloud" ]] && \
   [[ ${gcloud_db_proxy_enabled:-} != "false" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  echo
  echo "### gcloud/post: Stopping all db proxies"
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
