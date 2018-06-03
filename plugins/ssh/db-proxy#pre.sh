#!/bin/bash
: "${taito_cli_path:?}"

if [[ "${ssh_db_proxy:-}" ]]; then
  . ${taito_plugin_path}/util/opts.sh
  sh -c "ssh ${opts} -4 -f -o ExitOnForwardFailure=yes -L ${ssh_db_proxy} sleep 180"

  echo "Database connection details:"
  echo "- host: 127.0.0.1"
  echo "- port: ${database_port:-}"
  echo "- database: ${database_name:-}"
  echo "- username: ${database_username:-}, ${database_name}, ${database_name}_app, ${database_name}ap or your personal username"
  echo "- password: ${database_password:-?}"
  echo
  echo "Press enter to shutdown proxy"
  read -r
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
