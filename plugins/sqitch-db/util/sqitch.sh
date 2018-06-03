#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

# TODO clean this mess. duplicate code in clean.sh, psql.sh and sqitch.sh

command="${1}"
options="${@:2}"

sqitch_engine="${database_type:-pg}"

if [[ ! -f "./${taito_target:-database}/sqitch.conf" ]]; then
  echo "SKIP: File './${taito_target:-database}/sqitch.conf' does not exist."
  exit
fi

(
  cd "${taito_target:-database}" || exit

  if [[ ${sqitch_engine} == "mysql" ]]; then
    database_user="${database_name}ap"
  else
    database_user="${database_name}_app"
  fi
  if [[ "${database_username:-}" ]]; then
    database_user="${database_username}"
  fi
  sqitch_password="${database_password:-secret}"

  if [[ "${taito_env}" != "local" ]];then
    # TODO do not reference postgres plugin util directly
    . "${taito_cli_path}/plugins/postgres-db/util/postgres-username-password.sh"
    if [[ "${database_build_password}" != "" ]]; then
      database_user="${database_build_username}"
      sqitch_password="${database_build_password}"
    elif [[ "${database_build_username:-}" != "" ]]; then
      database_user="${database_build_username}"
      echo "Password for ${database_user}:"
      read -s -r sqitch_password
    fi
  fi

  echo "- sqitch: ${command}"

  export SQITCH_PASSWORD
  SQITCH_PASSWORD="${sqitch_password}"
  # TODO remove engine=pg default
  (${taito_setv:?}; sqitch --engine "${sqitch_engine:-pg}" \
    -h "${database_host}" -p "${database_port}" \
    -d "${database_name}" \
    -u "${database_user}" "${command}" "${@:2}")
)
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi
