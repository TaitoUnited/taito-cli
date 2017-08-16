#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_repo_name:?}"
: "${sentry_organization:?}"
: "${taito_project_path:?}"

echo
echo "### sentry - config: Creating a new project ###"
echo
echo "Create a new Sentry project with these settings:"
echo "- Name: ${taito_repo_name}"
echo "- Default environment: prod"
echo "- Alert when: 'An event is seen AND An event's environment equals prod'"
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
echo "Replacing Sentry DSN keys in heml.yaml and Dockerfile.build"
echo

if [[ -f "${taito_project_path}/scripts/helm.yaml" ]]; then
  {
    sed '/# SENTRY START/q' "${taito_project_path}/scripts/helm.yaml"
    echo "sentryDSN: ${dsn}"
    echo "sentryPublicDSN: ${dsn_public}"
    sed -n -e '/# SENTRY END/,$p' "${taito_project_path}/scripts/helm.yaml"
  } >> "${taito_project_path}/scripts/helm.yaml.tmp"
  mv -f "${taito_project_path}/scripts/helm.yaml.tmp" "${taito_project_path}/scripts/helm.yaml"
fi

if [[ -f "${taito_project_path}/client/Dockerfile.build" ]]; then
  {
    sed '/# SENTRY START/q' "${taito_project_path}/client/Dockerfile.build"
    echo "ENV APP_SENTRY_PUBLIC_DSN  ${dsn_public}"
    sed -n -e '/# SENTRY END/,$p' "${taito_project_path}/client/Dockerfile.build"
  } >> "${taito_project_path}/client/Dockerfile.build.tmp"
  mv -f "${taito_project_path}/client/Dockerfile.build.tmp" "${taito_project_path}/client/Dockerfile.build"
fi

if [[ -f "${taito_project_path}/admin/Dockerfile.build" ]]; then
  {
    sed '/# SENTRY START/q' "${taito_project_path}/admin/Dockerfile.build"
    echo "ENV APP_SENTRY_PUBLIC_DSN  ${dsn_public}"
    sed -n -e '/# SENTRY END/,$p' "${taito_project_path}/admin/Dockerfile.build"
  } >> "${taito_project_path}/admin/Dockerfile.build.tmp"
  mv -f "${taito_project_path}/admin/Dockerfile.build.tmp" "${taito_project_path}/admin/Dockerfile.build"
fi


# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
