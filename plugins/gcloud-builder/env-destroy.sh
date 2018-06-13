#!/bin/bash
: "${taito_cli_path:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder-trigger" "${name}"; then
  echo "TODO not implemented. Delete trigger manually."
  echo "Press enter when done"
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
