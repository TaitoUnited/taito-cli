#!/bin/bash
: "${taito_util_path:?}"

if [[ "${ssh_db_proxy:-}" ]]; then
  . ${taito_plugin_path}/util/opts.sh
  forward_value=$(echo "$ssh_db_proxy" | "${taito_util_path}/replace-variables.sh")
  (
    ${taito_setv:?}
    sh -c "ssh ${opts} -4 -f -o ExitOnForwardFailure=yes ${forward_value} sleep 180"
  )

  echo
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
"${taito_util_path}/call-next.sh" "${@}"
