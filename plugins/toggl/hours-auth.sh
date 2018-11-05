#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

hours_app=${1}

if "${taito_util_path}/confirm-execution.sh" "toggl" "${hours_app}" \
  "Authenticate to Toggl"
then
  "${taito_plugin_path}/util/auth.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
