#!/bin/bash
# NOTE: This bash script is run inside docker container.

# Resolve paths
# NOTE: duplicate with ./taito (taito_cli_path must be resolved before
# other scripts can be called)
export taito_home_path="${TAITO_HOME:-$HOME}"
export taito_cli_path
export taito_src_path
export taito_util_path
export taito_project_path
taito_cli_path=$(
  # Resolve taito-cli path by following symlinks
  source="${BASH_SOURCE[0]}"
  while [[ -h "${source}" ]]; do # resolve until the file is no longer a symlink
    dir="$( cd -P "$( dirname "${source}" )" && pwd )"
    source=$(readlink "${source}")
    [[ "${source}" != /* ]] && source="${taito_cli_path}/${source}"
  done
  dir=$(dirname "${source}")
  echo "${dir%/src}"
)
taito_src_path="${taito_cli_path}/src" && \
taito_util_path="${taito_cli_path}/src/util" && \
taito_project_path=$("${taito_src_path}/resolve-project-path.sh") && \

# Set working directory
cd "${taito_project_path}" && \

# Execute
"${taito_src_path}/execute-command.sh" "${@}"
