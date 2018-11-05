#!/bin/bash
: "${taito_plugin_path:?}"

export toggl_api_token
toggl_api_token=$(cat ~/.toggl/api-token 2> /dev/null || :)

if [[ ! "${toggl_api_token}" ]]; then
  echo "Toggl API token is missing. You need to authenticate first."
  "${taito_plugin_path}/util/auth.sh"
  toggl_api_token=$(cat ~/.toggl/api-token 2> /dev/null || :)
fi
