#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

if [[ "${taito_env}" == "prod" ]]; then
  echo "REMINDER: Configure Sentry if you have not already."
  echo
  echo "Press enter to continue."
  echo read -r
else
  echo "Finalize is required only for production."
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
