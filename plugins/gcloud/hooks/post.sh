#!/bin/bash
: "${taito_env:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ ${taito_env} != "local" ]] && \
   [[ ${taito_original_command_chain:-} == *"postgres/"* ]] && \
   [[ ${taito_command} != "ci-test-"* ]]; then
  echo
  echo "### gcloud - post: Killing all db proxies ###"
  echo
  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi
