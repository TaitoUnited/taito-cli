#!/bin/bash -e
: "${taito_util_path:?}"

hours_app=${1}

if "${taito_util_path}/confirm-execution.sh" "toggl" "${hours_app}" \
  "Authenticate to Toggl"
then
  echo "Get your personal API token from Toggl profile settings page and enter it below."
  while [[ ${#token} -lt 20 ]]; do
    echo "Personal Toggl API token:"
    read -r -s token
  done
  mkdir -p ~/.toggl
  echo "${token}" > ~/.toggl/api-token
  "${taito_cli_path}/util/docker-commit.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
