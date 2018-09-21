#!/bin/bash

export taito_extensions="./extension"
export taito_plugins="npm db-proxy db1 db2 example"

export taito_project="example"
export taito_environments="dev prod"
export taito_targets="client server"
export taito_databases="database reportdb"

# default database
export db_database_instance="common-postgres"
export db_database_type="pg"
export db_database_name="example_${taito_env}"
export db_database_host="localhost"
export db_database_proxy_port="5432"
export db_database_port="5001"

# report database
export db_reportdb_instance="common-postgres"
export db_reportdb_type="pg"
export db_reportdb_name="reportdb_${taito_env}"
export db_reportdb_host="localhost"
export db_reportdb_proxy_port="5432"
export db_reportdb_port="5002"
