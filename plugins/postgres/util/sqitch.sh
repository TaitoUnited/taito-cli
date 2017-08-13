#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

command="${1}"
options="${@:2}"

(
  cd database || exit

  . "${taito_plugin_path}/util/postgres-username-password.sh"

  if [[ "${taito_env}" == "local" ]];then
    database_user="${postgres_database}_app"
    sqitch_password="secret"
  elif [[ "${postgres_build_password}" != "" ]]; then
    database_user="${postgres_build_username}"
    sqitch_password="${postgres_build_password}"
  else
    database_user="${postgres_build_username}"
    echo "Password for ${database_user}:"
    read -s -r sqitch_password
  fi

  echo "- sqitch: ${command}"

  SQITCH_PASSWORD="${sqitch_password}" sqitch --engine pg \
    -h "${postgres_host}" -p "${postgres_port}" \
    -d "${postgres_database}" \
    -u "${database_user}" "${command}" "${@:2}"
  # shellcheck disable=SC2181
  if [[ $? -gt 0 ]]; then
    exit 1
  fi
)
