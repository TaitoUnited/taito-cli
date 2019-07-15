#!/bin/bash

. "${taito_util_path:?}/database-username-password.sh"

echo "- host: 127.0.0.1"
echo "- port: ${database_port:-}"
echo "- database: ${database_name:-}"

if [[ ${taito_mode:-} != "ci" ]]; then
  echo "- username and password:"
  echo "  * Your personal database username and password (if you have one)"
  if [[ "${database_mgr_username:-}" ]]; then
    echo "  * ${database_mgr_username} / ${database_build_password:-}"
  fi
  if [[ "${database_app_username:-}" ]]; then
    echo "  * ${database_app_username} / ${database_app_password:-}"
  fi
fi
