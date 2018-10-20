#!/bin/bash -e
: "${taito_util_path:?}"

hours_app=${1}

if "${taito_util_path}/confirm-execution.sh" "jira" "${hours_app}" \
  "Authenticate to JIRA"
then
  echo "TODO implement"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
