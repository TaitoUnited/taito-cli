#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${taito_repo_name:?}"
: "${taito_project:?}"

echo "gcloud-builder: Adding a build trigger for ${taito_project} in ${taito_zone}"
echo "Create a new build trigger with these settings if one does not exist already:"
echo "- Source: GitHub"
echo "- Repository: ${taito_repo_name}"
echo "- Name: ${taito_project}"
echo "- Type: Branch"
echo "- Branch regex: 'dev|test' or 'staging|master' depending on zone"
echo "- Build configuration: cloudbuild.yaml"
echo "- Cloudbuild.yaml location: /cloudbuild.yaml"
echo
echo "Press enter to open build trigger management"
read -r

"${taito_cli_path}/util/browser.sh" \
  "https://console.cloud.google.com/gcr/triggers?project=${taito_zone}" && \

echo "Press enter when ready" && \
read -r && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
