#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_app_url:?}"

if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_test:-}" == "true" ]]; then
  echo "Waiting for version change on ${taito_app_url}"

  echo "TODO implement version check instead of sleep"
  sleep 120
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
