#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_repo_name:?}"
: "${sentry_organization:?}"

echo
echo "### sentry - config: Creating a new project ###"
echo
echo "Create a new Sentry project with these settings:"
echo "- Name: ${taito_repo_name}"
echo "- TODO..."
echo
echo "Press enter to open Sentry"
read -r

if ! "${taito_cli_path}/util/browser.sh" "https://sentry.io/organizations/${sentry_organization}/projects/new/"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
