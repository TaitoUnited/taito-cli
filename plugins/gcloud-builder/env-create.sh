#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${taito_repo_name:?}"
: "${taito_project:?}"

branch="${1}"

echo
echo "### gcloud - env-create: Creating environment ###"
echo

# Determine branch
if [[ -z "${branch}" ]]; then
  if [[ "${taito_env}" == "prod" ]]; then
    branch="master"
  else
    branch="${taito_env}"
  fi
fi

echo
echo "gcloud-builder: Adding a build trigger for ${taito_env}"
echo
echo "Create a new build trigger with these settings:"
echo "- Source: GitHub"
echo "- Repository: ${taito_repo_name}"
echo "- Name: ${taito_project}-${taito_env}"
echo "- Type: Branch"
echo "- Branch regex: ${branch}"
echo "- Build configuration: cloudbuild.yaml"
echo "- Cloudbuild.yaml location: /cloudbuild.yaml"
echo
echo "Press enter to open build trigger management"
read -r

"${taito_cli_path}/util/browser.sh" \
  "https://console.cloud.google.com/gcr/triggers/add?project=${taito_zone}" && \

echo "Press enter when ready" && \
read -r && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
