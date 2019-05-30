#!/bin/bash

. "${taito_util_path:?}/database-username-password.sh"

echo "- host: 127.0.0.1"
echo "- port: ${database_port:-}"
echo "- database: ${database_name:-}"
echo "- username and password:"
echo "  * Your personal username and password"
echo "  * ${database_mgr_username:-} / ${database_build_password:-}"
echo "  * ${database_app_username:-} / ${database_app_password:-}"
