#!/bin/bash
: "${taito_cli_path:?}"

# TODO serverless.com support for fission?
if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_deploy:-}" != "false" ]]; then
  echo "TODO deploy fission function"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
