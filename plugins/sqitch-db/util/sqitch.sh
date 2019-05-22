#!/bin/bash
: "${taito_util_path:?}"
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

  # TODO: Remove? -\
  if [[ ${sqitch_engine} == "mysql" ]]; then
    database_user="${database_name}ap"
  else
    database_user="${database_name}_app"
  fi
  if [[ "${database_username:-}" ]]; then
    database_user="${database_username}"
  fi
  sqitch_password="${database_password:-$taito_default_password}"
  # TODO: Remove? -/

  if [[ "${taito_env}" != "local" ]];then
    # TODO do not reference postgres plugin util directly
    . "${taito_util_path}/database-username-password.sh"
    if [[ "${database_build_password}" != "" ]]; then
      database_user="${database_build_username}"
      sqitch_password="${database_build_password}"
    elif [[ "${database_build_username:-}" != "" ]]; then
      database_user="${database_build_username}"
      echo "Password for ${database_user}:"
      read -s -r sqitch_password
    fi
  fi

  sqitch_options=
  if [[ ${command} != "add" ]]; then
    sqitch_options="-h ${database_host} -p ${database_port} \
      -d ${database_name} -u ${database_user}"
  fi

  export SQITCH_PASSWORD
  SQITCH_PASSWORD="${sqitch_password}"
  (
    ${taito_setv:?}
    sqitch ${sqitch_options} "${command}" "${@:2}"
  )
)
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi
