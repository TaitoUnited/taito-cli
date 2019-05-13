#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_project_path:?}"

export taito_env="${1:-$taito_env}"
export taito_target_env="${taito_target_env:-$taito_env}"

if [[ -f "${taito_project_path}/taito-config.sh" ]]; then
  # Project specific configuration
  set -a
  # shellcheck disable=SC1090
  . "${taito_project_path}/taito-config.sh"
  set +a
fi

if [[ -f "${taito_project_path}/taito-user-config.sh" ]]; then
  # Project specific configuration of user
  set -a
  # shellcheck disable=SC1090
  . "${taito_project_path}/taito-user-config.sh"
  set +a
fi

# Set defaults
export taito_build_targets=${taito_build_targets:-$taito_targets}

# For backwards compatibility
# TODO remove
export taito_plugins="${taito_plugins/ secrets/ generate-secrets}"
export taito_plugins="${taito_plugins/ semantic / semantic-release }"

# For backwards compatibility
# TODO remove
export dockerfile=Dockerfile
if [[ ${taito_repo_name:-} ]]; then
  export taito_vc_repository=${taito_repo_name:?}
  export taito_container_registry=${taito_registry:-}
fi
