#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

. "${taito_plugin_path}/util/postgres-username-password.sh"

if [[ -n ${postgres_build_password:-} ]] && [[ -n ${postgres_app_password:-} ]]; then
  echo
  echo "### postgres - env-rotate: Creating users / altering passwords for \
  ${taito_env} ###"

  export postgres_username=postgres
  "${taito_plugin_path}/util/create-users.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
