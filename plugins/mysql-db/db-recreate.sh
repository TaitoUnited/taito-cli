#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  # Create a subshell to contain password
  (
    export database_username=${database_master_username:-root}
    echo "HINT: You can get the ${database_username} user password from:"
    echo "${database_master_password_hint:-}"
    echo "TODO implement"
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
