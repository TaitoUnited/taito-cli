#!/usr/bin/env bash -e
# NOTE: This bash script is run directly on host.

export taito_env="${1:-$taito_env}"
export taito_target_env="${taito_target_env:-$taito_env}"

# Personal default configuration
if [[ -f "${taito_home_path}/.taito/taito-config.sh" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "${taito_home_path}/.taito/taito-config.sh"
  set +a
fi

# Personal organization specific configuration
org_config_file=""
if [[ "${taito_organization_param:-}" ]]; then
  org_config_file="${taito_home_path}/.taito/taito-config-${taito_organization_param}"
fi

if [[ "$org_config_file" ]] && [[ -f "${org_config_file}" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "${org_config_file}"
  set +a
elif [[ "$org_config_file" ]]; then
  echo
  echo "ERROR: Taito config file not found: $org_config_file"
  exit 1
fi
