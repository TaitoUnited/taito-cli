#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

export taito_env="${1:-$taito_env}"
export taito_target_env="${taito_target_env:-$taito_env}"

# Personal default configuration
if [[ -f "${taito_home_path}/.taito/taito-config.sh" ]]; then
  # shellcheck disable=SC1090
  . "${taito_home_path}/.taito/taito-config.sh"
fi
# Personal organization specific configuration
if [[ -f "${taito_home_path}/.taito/taito-config-${taito_organization_param:-}.sh" ]]; then
  # shellcheck disable=SC1090
  . "${taito_home_path}/.taito/taito-config.sh"
fi