#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_app_url:?}"

# Wait for deployment only if tests are executed after
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
  echo "Skipping deployment wait because ci_exec_test != true"
else
  # Call next command on command chain
  "${taito_cli_path}/util/call-next.sh" "${@}"
fi
