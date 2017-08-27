#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### serverless - revert: Reverting ###"
echo

revision="${1}"
if [[ "${revision}" == "" ]]; then
  revision=0
fi

echo "TODO revert aws/azure/gcloud function using serverless.com";
exit 1

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
