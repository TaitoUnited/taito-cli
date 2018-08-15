#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_zone:?}"
: "${taito_project:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder-trigger" "${name}" \
  "Remove build trigger of ${taito_project} from ${taito_zone}"
then
  echo "Delete trigger manually. Press enter to open build trigger management."
  read -r
  "${taito_cli_path}/util/browser.sh" \
    "https://console.cloud.google.com/cloud-build/triggers?project=${taito_zone}" && \
  echo "Press enter when you have deleted the trigger."
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
