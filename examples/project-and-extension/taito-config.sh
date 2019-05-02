#!/bin/sh
# shellcheck disable=SC2034
: "${taito_target_env:?}"

taito_extensions="./extension"
taito_plugins="npm db-proxy db1 db2 example"

taito_project="example-project"
taito_environments="dev prod"
taito_env=$taito_target_env
taito_targets="client server"
taito_databases="database reportdb"
taito_storages="example-project-${taito_env}"

# default database
db_database_instance="common-postgres"
db_database_type="pg"
db_database_name="example_${taito_env}"
db_database_host="localhost"
db_database_port="5001"

# report database
db_reportdb_instance="common-postgres"
db_reportdb_type="pg"
db_reportdb_name="reportdb_${taito_env}"
db_reportdb_host="localhost"
db_reportdb_proxy_port="5432"
db_reportdb_port="5002"
