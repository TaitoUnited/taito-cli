#!/bin/bash
: "${taito_util_path:?}"
: "${taito_zone:?}"
: "${taito_project:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "gcp-ci-trigger" "${name}" \
  "Remove build trigger of ${taito_project} from ${taito_zone}"
then
  echo "Delete trigger manually. Press enter to open build trigger management."
  read -r
  opts=""
  if [[ ${google_authuser:-} ]]; then
    opts="authuser=${google_authuser}&"
  fi
  "${taito_util_path}/browser.sh" \
    "https://console.cloud.google.com/cloud-build/triggers?${opts}project=${taito_zone}" && \
  echo "Press enter when you have deleted the trigger."
  read -r
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"