#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_zone:?}"
: "${taito_project:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder-trigger" "${name}" \
  "Remove build trigger of ${taito_project} from ${taito_zone}"
then
  echo "TODO not implemented. Delete trigger manually."
  echo "Press enter when done"
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
