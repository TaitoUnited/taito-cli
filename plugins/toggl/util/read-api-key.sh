#!/bin/bash -e

export toggl_api_key
toggl_api_key=$(cat ~/.toggl/api-key)

if [[ ! "${toggl_api_key}" ]]; then
  echo "Toggl API KEY is missing. Authenticate with 'taito hours auth: toggl'"
fi
