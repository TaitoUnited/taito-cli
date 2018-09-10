#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || ( \
    [[ "${taito_command:-}" == "test" ]] &&
    [[ "${taito_plugins:-}" == *"gcloud-builder"* ]] &&
    [[ "${taito_mode:-}" == "ci" ]] \
  ); then
  echo
  echo "### gcloud/post: Stopping all db proxies"

  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
