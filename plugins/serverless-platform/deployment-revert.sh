#!/bin/bash
: "${taito_util_path:?}"

revision="${1:-0}"

echo "TODO revert aws/azure/gcloud function using serverless.com" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
