#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${taito_project_path:?}"

# TODO clean this mess. duplicate code in clean.sh, psql.sh and sqitch.sh

if [[ "${taito_env}" == "prod"* ]]; then
  echo "postgres-db/clean.sh: 'clean' is not allowed for production environment"
  exit 1
fi

(
  export PGPASSWORD

  database_user="${database_name}_app"
  if [[ "${database_username:-}" ]]; then
    database_user="${database_username}"
  fi
  PGPASSWORD="${database_password:-secret}"

  if [[ "${taito_env}" != "local" ]];then
    # TODO: copy-pasted from sqitch.sh -->
    . "${taito_plugin_path}/util/postgres-username-password.sh"
    if [[ "${database_build_password:-}" != "" ]]; then
      database_user="${database_build_username:-}"
      PGPASSWORD="${database_build_password}"
    elif [[ "${database_build_username:-}" != "" ]]; then
      database_user="${database_build_username}"
      echo "Password for ${database_user}:"
      read -s -r PGPASSWORD
    fi
  fi && \

  # Drop all but the default schemas
  echo && \
  echo "- import ./database/clean.sql" && \
  (${taito_setv:?}; psql -h "${database_host}" -p "${database_port}" \
    -d "${database_name}" \
    -U "${database_user}" \
    -f "${taito_plugin_path}/resources/clean.sql") && \

  # Drop all content in public schema
  # TODO currently drops only tables
  # NOTE: we could drop and create public schema instead, if public schema was
  # owned by ${database_user}
  tmp_file="${taito_project_path}/tmp/drop.sql" && \
  mkdir -p "${taito_project_path}/tmp" &> /dev/null && \
  rm -f "${tmp_file}" &> /dev/null && \

  (${taito_setv:?}; psql -h "${database_host}" -p "${database_port}" \
    -d "${database_name}" \
    -U "${database_user}" \
    -t \
    -c "SELECT 'DROP TABLE ' || n.nspname || '.' || c.relname || ' CASCADE;' FROM pg_catalog.pg_class AS c LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace WHERE relkind = 'r' AND n.nspname NOT IN ('pg_catalog', 'pg_toast') AND pg_catalog.pg_table_is_visible(c.oid)" \
    > "${tmp_file}") && \

  echo && \
  echo "- import ${tmp_file}" && \
  (${taito_setv:?}; psql -h "${database_host}" -p "${database_port}" \
    -d "${database_name}" \
    -U "${database_user}" \
    -f "${tmp_file}") && \

  rm -f "${tmp_file}" &> /dev/null && \

  # TODO: copy-pasted from create-database.sh -->

  # Run init.sql of project
  echo && \
  echo "- import ./database/init.sql" && \
  (${taito_setv:?}; psql -h "${database_host}" \
    -p "${database_port}" -d "${database_name}" \
     -U "${database_user}" < ./database/init.sql)
)
