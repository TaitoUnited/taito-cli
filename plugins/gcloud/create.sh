#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

branch="${1}"

echo
echo "### gcloud - create: Creating environment ###"
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
  echo "Create an uptime with these settings:"
  echo "- Title: ${taito_project}-${taito_env}"
  echo "- Type: HTTPS"
  echo "- Hostname: ${taito_app_url}"
  echo "- Path: /statusz"
  echo "- Check every: 5 minutes"
  echo
  echo "Press enter to open the uptime check management"
  read -r
  echo "Press enter when ready"
  read -r
  echo

  if ! "${taito_cli_path}/util/browser.sh" "https://app.google.stackdriver.com/uptime?project=${taito_zone}"; then
    exit 1
  fi

  echo
  echo "gcloud: Adding a log alerts for ${taito_env}"
  echo
  echo "TODO create some log alerts..."
  echo
  echo "Press enter to open logs"
  read -r
  echo "Press enter when ready"
  read -r
  echo

  if ! "${taito_cli_path}/util/browser.sh" "${link_logs_url_prefix}-${taito_env}"; then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
