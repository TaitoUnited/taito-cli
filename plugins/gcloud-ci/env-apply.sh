#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${taito_vc_repository:?}"
: "${taito_project:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-ci" "${name}" \
  "Add a build trigger for ${taito_project} in ${taito_zone}"
then
  echo "Create a new build trigger with these settings if one does not exist already:"
  echo "- Source: GitHub"
  echo "- Repository: ${taito_vc_repository}"
  echo "- Name: ${taito_project}"
  echo "- Type: Branch"
  echo "- Branch regex: '^(dev|test)\$' or '^(stag|canary|master)\$' depending on zone"
  echo "- Build configuration: cloudbuild.yaml"
  echo "- Cloudbuild.yaml location: /cloudbuild.yaml"
  echo
  echo "Press enter to open build trigger management"
  read -r

  opts=""
  if [[ ${google_authuser:-} ]]; then
    opts="authuser=${google_authuser}&"
  fi

  "${taito_cli_path}/util/browser.sh" \
    "https://console.cloud.google.com/cloud-build/triggers?${opts}project=${taito_zone}" && \

  echo "Press enter when ready" && \
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"