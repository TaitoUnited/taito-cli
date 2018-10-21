#!/bin/bash

export toggl_api_token
toggl_api_token=$(cat ~/.toggl/api-token 2> /dev/null || :)

if [[ ! "${toggl_api_token}" ]]; then
  echo "Toggl API token is missing. Authenticate with 'taito hours auth: toggl'"
  exit 1
fi
