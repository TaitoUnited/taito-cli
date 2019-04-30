#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "aws" "${name}" \
  "Show manual configuration steps?"
then
  echo "TODO: The following have not yet been automatized:"
  echo
  echo "1) Configure database endpoints in 'terraform/tcp-proxy.yaml'.
  echo     NOTE: Do this before installing helm releases!"
  echo
  echo "2) Configure 'taito_provider_region_hexchars' in taito-config.sh. You can determine"
  echo "   hexchars by looking at your database endpoint URL. Hexchars is a 12 characters"
  echo "   long random string."
  echo
  echo "Press enter to continue"
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
