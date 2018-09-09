#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || ( \
     [[ ${taito_command:-} == "test" ]] && \
     [[ ${ci_exec_test_db_proxy:-} == "true" ]] && \
     [[ ${taito_env:-} != "local" ]] \
   ); then

  if [[ "${taito_command}" == "test" ]] && [[ "${taito_env}" != "ci" ]]; then
    sleep 10
    echo
    echo "### gcloud/post: Stopping all db proxies"
    echo "NOTE: Press enter once all tests have been run"
    read -r
  else
    echo
    echo "### gcloud/post: Stopping all db proxies"
  fi

  "${taito_plugin_path}/util/db-proxy-stop.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
