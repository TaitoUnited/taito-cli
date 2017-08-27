#!/bin/bash

: "${taito_cli_path:?}"

# image="${1}"
# options=("${@:2}")

echo
echo "### serverless - deploy: Deploying ###"
echo

echo "TODO deploy aws/azure/gcloud function using serverless.com";
exit 1

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
