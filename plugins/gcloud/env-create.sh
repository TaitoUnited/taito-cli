#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

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

if [[ "${taito_env}" == "prod" ]]; then
  echo
  echo "gcloud: Configuring DNS for ${taito_env}"
  echo
  echo "TODO implement: Add DNS entry with gcloud cli"
  echo "NOTE: Configure DNS manually and press enter"
  echo
  echo "Press enter to TODO"
  read -r
  echo
  echo "Press enter when ready"
  read -r
  echo

  echo
  echo "gcloud: Adding a uptime check for ${taito_env}"
  echo
  echo "Create two uptime checks with these settings:"
  echo "- Title: ${taito_project}-${taito_env}"
  echo "- Type: HTTPS"
  echo "- Hostname: ${taito_app_url}"
  echo "- Path: / and /api/uptimez"
  echo "- Check every: 1 minute"
  echo "- Do not create a new policy. Add to the existing 'Uptime Check Policy' instead."
  echo "Press enter to open the uptime check management"
  read -r
  if ! "${taito_cli_path}/util/browser.sh" "https://app.google.stackdriver.com/uptime?project=${taito_zone}"; then
    exit 1
  fi
  echo "Press enter when ready"
  read -r
  echo

  echo
  echo "gcloud: Adding a log alerts for ${taito_env}"
  echo
  echo "TODO create some log alerts..."
  echo
  echo "Press enter to open logs"
  read -r
  if ! "${taito_cli_path}/util/browser.sh" "https://console.cloud.google.com/logs/viewer?project=${taito_zone}&minLogLevel=0&expandAll=false&resource=container%2Fcluster_name%2F${kubectl_name}%2Fnamespace_id%2F${taito_namespace}"; then
    exit 1
  fi
  echo "Press enter when ready"
  read -r
  echo

fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
