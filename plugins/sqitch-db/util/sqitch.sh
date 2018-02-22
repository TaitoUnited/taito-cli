#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

command="${1}"
options="${@:2}"

sqitch_engine="${sqitch_engine:-pg}"

(
  cd database || exit

  # TODO mysql support

  # TODO do not reference postgres plugin util directly
  . "${taito_cli_path}/plugins/postgres-db/util/postgres-username-password.sh"

  if [[ "${taito_env}" == "local" ]];then
    database_user="${database_name}_app"
    sqitch_password="secret"
  elif [[ "${database_build_password}" != "" ]]; then
    database_user="${database_build_username}"
    sqitch_password="${database_build_password}"
  else
    database_user="${database_build_username}"
    echo "Password for ${database_user}:"
    read -s -r sqitch_password
  fi

  echo "- sqitch: ${command}"

  # TODO remove pg default
  SQITCH_PASSWORD="${sqitch_password}" sqitch --engine "${sqitch_engine:-pg}" \
    -h "${database_host}" -p "${database_port}" \
    -d "${database_name}" \
    -u "${database_user}" "${command}" "${@:2}"
)
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi
