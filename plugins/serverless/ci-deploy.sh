#!/bin/bash

: "${taito_cli_path:?}"

echo "TODO deploy aws/azure/gcloud function using serverless.com" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
