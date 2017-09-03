#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

branch="${1}"

echo
echo "### jenkins - env-create: Creating a build trigger ###"
echo

# Determine branch
if [[ -z "${branch}" ]]; then
  if [[ "${taito_env}" == "prod" ]]; then
    branch="master"
  else
    branch="${taito_env}"
  fi
fi

echo "TODO create jenkins trigger" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
