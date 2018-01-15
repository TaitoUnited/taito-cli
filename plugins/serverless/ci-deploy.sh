#!/bin/bash

: "${taito_cli_path:?}"

if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_deploy:-}" != false ]]; then
  echo "TODO deploy aws/azure/gcloud function using serverless.com"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
