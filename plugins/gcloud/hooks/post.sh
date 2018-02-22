#!/bin/bash
: "${taito_plugin_path:?}"

if [[ ${taito_command_chain:-} == *"-db/"* ]]; then
  echo "### gcloud/post: Stopping all db proxies"
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi
