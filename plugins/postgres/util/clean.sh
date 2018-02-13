#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"
: "${taito_project_path:?}"

(
  # TODO: copy-pasted from sqitch.sh -->
  . "${taito_plugin_path}/util/postgres-username-password.sh"

  if [[ "${taito_env}" == "local" ]];then
    database_user="${postgres_database}_app"
    PGPASSWORD="secret"
  elif [[ "${postgres_build_password}" != "" ]]; then
    database_user="${postgres_build_username}"
    PGPASSWORD="${postgres_build_password}"
  else
    database_user="${postgres_build_username}"
    echo "Password for ${database_user}:"
    read -s -r PGPASSWORD
  fi && \

  # Drop all but the default schemas
  echo && \
  echo "- import ./database/clean.sql" && \
  PGPASSWORD="${PGPASSWORD}" \
    psql -h "${postgres_host}" -p "${postgres_port}" \
    -d "${postgres_database}" \
    -U "${database_user}" \
    -f "${taito_plugin_path}/resources/clean.sql" && \

  # Drop all content in public schema
  # TODO currently drops only tables
  # NOTE: we could drop and create public schema instead, if public schema was
  # owned by ${database_user}
  tmp_file="${taito_project_path}/tmp/drop.sql" && \
  mkdir -p "${taito_project_path}/tmp" &> /dev/null && \
  rm -f "${tmp_file}" &> /dev/null && \

  PGPASSWORD="${PGPASSWORD}" \
    psql -h "${postgres_host}" -p "${postgres_port}" \
    -d "${postgres_database}" \
    -U "${database_user}" \
    -t \
    -c "SELECT 'DROP TABLE ' || n.nspname || '.' || c.relname || ' CASCADE;' FROM pg_catalog.pg_class AS c LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace WHERE relkind = 'r' AND n.nspname NOT IN ('pg_catalog', 'pg_toast') AND pg_catalog.pg_table_is_visible(c.oid)" \
    > "${tmp_file}" && \

  echo && \
  echo "- import ${tmp_file}" && \
  PGPASSWORD="${PGPASSWORD}" \
    psql -h "${postgres_host}" -p "${postgres_port}" \
    -d "${postgres_database}" \
    -U "${database_user}" \
    -f "${tmp_file}" && \

  rm -f "${tmp_file}" &> /dev/null && \

  # TODO: copy-pasted from create-database.sh -->

  # Run init.sql of project
  echo && \
  echo "- import ./database/init.sql" && \
  PGPASSWORD="${PGPASSWORD}" psql -h "${postgres_host}" \
    -p "${postgres_port}" -d "${postgres_database}" \
     -U "${database_user}" < ./database/init.sql
)
