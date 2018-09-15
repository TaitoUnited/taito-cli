#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_project_path:?}"

export taito_env="${1:-$taito_env}"
export taito_target_env="${taito_target_env:-$taito_env}"

# Read taito-config.sh files from all locations
if [[ -f "${taito_home_path}/.taito/taito-config.sh" ]]; then
  # Personal config
  # shellcheck disable=SC1090
  . "${taito_home_path}/.taito/taito-config.sh"
fi
if [[ -f "${taito_project_path}/taito-config.sh" ]]; then
  # Project specific config
  # shellcheck disable=SC1091
  . "${taito_project_path}/taito-config.sh"
fi

# For backwards compatibility
# TODO remove gcloud_sql_proxy_port from all projects
if [[ -n "${gcloud_sql_proxy_port:-}" ]] && \
   [[ -z "${database_proxy_port}" ]]; then
  export database_proxy_port="${gcloud_sql_proxy_port}"
fi
