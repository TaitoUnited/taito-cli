#!/bin/bash
# shellcheck source=../../postgres-db/lib/exec.bash"
. "${taito_plugin_path:?}/../postgres-db/lib/exec.bash"
. "${taito_plugin_path:?}/../mysql-db/lib/exec.bash"

function sqitch::deploy () {
  sqitch::run deploy --set env="'${taito_env}'"
}

function sqitch::run () {
  # TODO clean this mess. duplicate code in clean, psql and sqitch

  local command="${1}"
  local options="${@:2}"

  local sqitch_engine="${database_type:-pg}"

  if [[ ! -f "./${taito_target:-database}/sqitch.conf" ]]; then
    echo "SKIP: File './${taito_target:-database}/sqitch.conf' does not exist."
    exit
  fi

  (
    cd "${taito_target:-database}" || exit

    # TODO: Remove? -\
    if [[ ${sqitch_engine} == "mysql" ]]; then
      database_user="root"
    else
      database_user="${database_name}_app"
    fi
    if [[ ${database_username:-} ]]; then
      database_user="${database_username}"
    fi
    sqitch_password="${database_password:-$taito_default_password}"
    # TODO: Remove? -/

    if [[ ${taito_env} != "local" ]];then
      # TODO do not reference postgres plugin util directly
      taito::expose_db_user_credentials
      if [[ ${database_build_password} != "" ]]; then
        database_user="${database_build_username}"
        sqitch_password="${database_build_password}"
      elif [[ ${database_build_username:-} != "" ]]; then
        database_user="${database_build_username}"
        echo "Password for ${database_user}:"
        read -s -r sqitch_password
      fi
    fi

    sqitch_options=
    if [[ ${command} != "add" ]]; then
      sqitch_options="-h ${database_host} -p ${database_port} \
        -d ${database_name} -u ${database_user}"

      # TODO: use table prefix or create a separate database?
      # see https://github.com/sqitchers/sqitch/pull/247
      if [[ ${sqitch_engine} == "mysql" ]]; then
        sqitch_options="${sqitch_options} --registry ${database_name} $(mysql::print_ssl_options | sed 's/--/--set /g')"
      fi
    fi

    if [[ ${sqitch_engine} == "pg" ]]; then
      postgres::export_pgsslmode
    fi

    export SQITCH_PASSWORD
    SQITCH_PASSWORD="${sqitch_password}"
    (
      taito::executing_start
      sqitch ${sqitch_options} "${command}" "${@:2}"
    )
  )
  # shellcheck disable=SC2181
  if [[ $? -gt 0 ]]; then
    exit 1
  fi
}
