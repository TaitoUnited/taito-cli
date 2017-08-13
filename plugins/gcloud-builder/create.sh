#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${gcloud_builder_dns_enabled:?}"
: "${gcloud_builder_monitoring_enabled:?}"
: "${gcloud_builder_log_alerts_enabled:?}"

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

echo
echo "gcloud: Adding a build trigger for ${taito_env}"
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

if ! "${taito_cli_path}/util/browser.sh" "https://console.cloud.google.com/gcr/triggers/add?project=${taito_zone}"; then
  exit 1
fi

if [[ "${taito_env}" == "prod" ]]; then
  if [[ "${gcloud_builder_dns_enabled}" == true ]]; then
    echo
    echo "gcloud: Configuring DNS for ${taito_env}"
    echo
    echo "TODO implement: Add DNS entry with gcloud cli"
    echo "NOTE: Configure DNS manually and press enter"
    echo
    echo "Press enter to TODO"
    read -r
    echo
  fi

  echo
  echo "gcloud: Configuring SSL certificate for ${taito_env}"
  echo
  echo "Use Let's Encrypt certificate? (Y/n)"
  read -r use_lets_encrypt
  if [[ "${use_lets_encrypt}" == "n" ]]; then
    echo "TODO implement: Add cert"
    echo "NOTE: Add SSL cert manually with \'taito cert\' command and press enter"
    echo
    echo "Press enter to TODO"
    read -r
    echo
  else
    echo
    echo "OK! All done!"
  fi

  if [[ "${gcloud_builder_monitoring_enabled}" == true ]]; then
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

    if ! "${taito_cli_path}/util/browser.sh" "https://app.google.stackdriver.com/uptime?project=${taito_zone}"; then
      exit 1
    fi
  fi

  if [[ "${gcloud_builder_log_alerts_enabled}" == true ]]; then
    echo
    echo "gcloud: Adding a log alerts for ${taito_env}"
    echo
    echo "TODO create some log alerts..."
    echo
    echo "Press enter to open logs"
    read -r

    if ! "${taito_cli_path}/util/browser.sh" "${link_logs_url_prefix}-${taito_env}"; then
      exit 1
    fi
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
