#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

if [[ "${taito_target_env}" == "prod" ]]; then
  echo "TODO not implemented. Delete these manually:"
  echo "- DNS settings"
  echo "- Uptime check"
  echo "- Log alert rules"
  echo
  echo "Press enter when done"
  read -r
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
