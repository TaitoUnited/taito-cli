#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${taito_vc_repository:?}"
: "${taito_project:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "gcp-ci" "${name}" \
  "Add a build trigger for ${taito_project} in ${taito_zone}"
then
  echo "Create a new build trigger with these settings if one does not exist already:"
  echo "- Source: ${taito_vc_provider:-GitHub}"
  echo "- Repository: ${taito_vc_repository}"
  echo "- Name: ${taito_project}"
  echo "- Type: Branch"
  echo "- Branch regex - Most likely one of these depending on zone:"
  echo "    ^(dev|test)\$"
  echo "    ^(stag|canary|master)\$"
  echo "- Build configuration: Cloud Build configuration file (yaml or json)"
  echo "- Cloudbuild.yaml location: /cloudbuild.yaml"
  echo
  echo "Press enter to open build trigger management"
  read -r

  opts=""
  if [[ ${google_authuser:-} ]]; then
    opts="authuser=${google_authuser}&"
  fi

  "${taito_util_path}/browser.sh" \
    "https://console.cloud.google.com/cloud-build/triggers?${opts}project=${taito_zone}" && \

  echo "Press enter when ready" && \
  read -r
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
