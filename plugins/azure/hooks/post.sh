#!/bin/bash
: "${taito_env:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ ${taito_env} != "local" ]] && \
   [[ ${taito_original_command_chain:-} == *"postgres/"* ]] && \
   [[ ${taito_command} != "ci-test-"* ]]; then
  echo
  echo "### azure - post: Stopping all db proxies ###"
  echo "TODO implement"
fi
