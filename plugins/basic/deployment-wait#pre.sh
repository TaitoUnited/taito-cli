#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_app_url:?}"
: "${taito_target_env:?}"

# Wait for deployment only if tests are executed after
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
  echo "Skipping deployment wait because ci_exec_test != true"
  echo
  echo
  echo
  echo
  echo "------------------------------------------------------"
  echo "NOTE: Your application is now starting up at ${taito_target_env}!"
  echo "------------------------------------------------------"
  echo
  echo
  echo
  echo
else
  # Call next command on command chain
  "${taito_cli_path}/util/call-next.sh" "${@}"
  echo
  echo
  echo
  echo
  echo "------------------------------------------------------"
  echo "NOTE: Your application is now running at ${taito_target_env}!"
  echo "------------------------------------------------------"
  echo
  echo
  echo
  echo
fi
