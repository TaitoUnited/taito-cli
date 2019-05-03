#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "custom" "${name}" \
  "Execute zone specific custom doctoring"
then
  echo "TODO"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
