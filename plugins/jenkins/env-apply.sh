#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_zone:?}"
: "${taito_project:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "jenkins-trigger" "${name}" \
  "Add a build trigger for ${taito_project} in ${taito_zone}"
then
  echo "TODO create build trigger"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
