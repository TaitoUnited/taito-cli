#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

echo "TODO execute for all mysql databases"
if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  echo "TODO implement"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
