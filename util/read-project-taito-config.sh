#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_project_path:?}"

export taito_env="${1:-$taito_env}"
export taito_target_env="${taito_target_env:-$taito_env}"

if [[ -f "${taito_project_path}/taito-config.sh" ]]; then
  # Project specific configuration
  # shellcheck disable=SC1091
  . "${taito_project_path}/taito-config.sh"
fi

# For backwards compatibility
# TODO remove gcloud_sql_proxy_port from all projects
if [[ -n "${gcloud_sql_proxy_port:-}" ]] && \
   [[ -z "${database_proxy_port}" ]]; then
  export database_proxy_port="${gcloud_sql_proxy_port}"
fi

# For backwards compatibility
# TODO remove
export taito_plugins="${taito_plugins/ secrets/ generate-secrets}"
