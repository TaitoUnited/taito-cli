#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"

if [[ "${taito_target_env}" == "prod" ]]; then
  echo "NOTE: Delete these manually:"
  echo "- DNS settings"
  echo "- Optional: Custom log alert rules defined for the project"
  echo
  echo "Press enter when done"
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
