#!/bin/bash

if [[ -n "${database_proxy_port:-}" ]]; then
  # kill cloud_sql_proxy
  (${taito_setv:?}; pgrep cloud_sql_proxy | xargs kill)
  echo "- proxy stopped"
fi
