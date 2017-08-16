#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_repo_name:?}"
: "${sentry_organization:?}"

echo
echo "### sentry - config: Creating a new project ###"
echo
echo "Create a new Sentry project with these settings:"
echo "- Name: ${taito_repo_name}"
echo "- Alert when: 'An event's environment equals prod'"
echo "- Enable Slack integration: Send alerts to random channel"
echo
echo "Press enter to open Sentry"
read -r

if ! "${taito_cli_path}/util/browser.sh" "https://sentry.io/organizations/${sentry_organization}/projects/new/"; then
  exit 1
fi

echo "Press enter when ready"
read -r

echo "Sentry DSN key?"
read -r dsn

echo "Sentry public DSN key?"
read -r dsn_public

echo
echo "Replacing Sentry DSN keys in ./scripts/heml.yaml"
echo
{
  sed '/# SENTRY START/q' ./scripts/helm.yaml
  echo "sentryDSN: ${dsn}"
  echo "sentryPublicDSN: ${dsn_public}"
  sed -n -e '/# SENTRY END/,$p' ./scripts/helm.yaml
} >> ./scripts/helm.yaml.tmp
mv -f ./scripts/helm.yaml.tmp ./scripts/helm.yaml


# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
