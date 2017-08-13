#!/bin/bash
: "${taito_env:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_env} != "local" ]] && [[ ${taito_command_chain} == *"postgres/"* ]]; then
  echo
  echo "### gcloud - post: Killing all db proxies ###"
  echo
  if ! "${taito_plugin_path}/util/db-proxy-stop.sh"; then
    exit 1
  fi
fi
