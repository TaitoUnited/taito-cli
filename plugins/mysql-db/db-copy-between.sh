#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_dest_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  source="${taito_env}"
  dest="${taito_dest_env}"
  username="${1:-root}"

  echo "TODO implement"
  echo "${database_instance}"
  echo "${database_name}"
  echo "${database_host}"
  echo "${database_port}"

fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
