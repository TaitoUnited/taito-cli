#!/bin/bash

if [[ ${gcloud_db_proxy_enabled:-} != "false" ]]; then
  # kill cloud_sql_proxy
  (${taito_setv:?}; pgrep cloud_sql_proxy | xargs kill)
fi
