#!/bin/bash -e
: "${taito_util_path:?}"

echo "Get your personal API token from Toggl profile settings page and enter it below."
while [[ ${#token} -lt 20 ]]; do
  echo "Personal Toggl API token:"
  read -r -s token
done
mkdir -p ~/.toggl
echo "${token}" > ~/.toggl/api-token
"${taito_util_path}/docker-commit.sh"
