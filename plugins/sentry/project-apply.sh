#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_vc_repository:?}"
: "${sentry_organization:?}"
: "${taito_project_path:?}"

echo "Create a new Sentry project with these settings:"
echo "- Name: ${taito_vc_repository}"
echo "- Default environment: prod"
echo "- Alert when: 'An event is seen AND An event's environment equals prod'"
echo "- Enable Slack integration: Send alerts to monitoring channel"
echo "- Configure alert: Alert every time 'all' of these conditions are met: \
'An event is seen AND An event's environment equals prod' take these actions \
'Send a notification to Slack'. Perform these actions at most once every \
'30 minutes' for an issue."

echo
echo "NOTE: If you don't want to create the Sentry project right now,"
echo "just press enter for all Sentry related questions. You can run"
echo "'taito project apply' again later when you are ready to create the"
echo "Sentry project."
echo
echo "Press enter to open Sentry"
read -r

"${taito_cli_path}/util/browser.sh" \
  "https://sentry.io/organizations/${sentry_organization}/projects/new/"

echo "Press enter when ready"
read -r

echo "Sentry public DSN url?"
read -r dsn_public
if [[ -z "${dsn_public}" ]]; then
  dsn_public="#sentryPublicDSN"
fi

echo "Sentry private DSN url?"
read -r dsn
if [[ -z "${dsn}" ]]; then
  dsn="#sentryDSN"
fi

echo "Replacing Sentry DSN keys in heml.yaml and Dockerfile.build"
echo

if [[ -f "${taito_project_path}/scripts/helm.yaml" ]]; then
  sed -i -- "s/#sentryDSN/${dsn}/g" "${taito_project_path}/scripts/helm.yaml"
  sed -i -- "s/#sentryPublicDSN/${dsn_public}/g" "${taito_project_path}/scripts/helm.yaml"
fi

if [[ -f "${taito_project_path}/client/Dockerfile.build" ]]; then
  sed -i -- "s/#sentryPublicDSN/${dsn_public}/g" "${taito_project_path}/client/Dockerfile.build"
fi

if [[ -f "${taito_project_path}/admin/Dockerfile.build" ]]; then
  sed -i -- "s/#sentryPublicDSN/${dsn_public}/g" "${taito_project_path}/admin/Dockerfile.build"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
