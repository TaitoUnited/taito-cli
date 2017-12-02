#!/bin/bash
: "${taito_env:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ ${taito_env} != "local" ]] && \
   [[ ${taito_original_command_chain:-} == *"postgres/"* ]] && \
   [[ ${taito_command} != "ci-test-"* ]]; then
  echo "### gcloud/post: Stopping all db proxies"
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi
