#!/bin/bash

export toggl_api_key
toggl_api_key=$(cat ~/.toggl/api-key 2> /dev/null || :)

if [[ ! "${toggl_api_key}" ]]; then
  echo "Toggl API KEY is missing. Authenticate with 'taito hours auth: toggl'"
  exit 1
fi
