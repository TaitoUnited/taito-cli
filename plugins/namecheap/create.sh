#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

branch="${1}"

echo
echo "### namecheap - create: Adding a SSL certificate ###"
echo

if [[ "${taito_env}" == "prod" ]] || [[ "${branch}" == "master" ]]; then
  echo
  echo "TODO implement: Certificate process between namecheap and"
  echo "kubectl plugins by passing secrets in environment variables."
  echo
  echo "NOTE: Not implmented. Configure cert manually."
  echo
  echo "Press enter when ready"
  read -r
  echo
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
