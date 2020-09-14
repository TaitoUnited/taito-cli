#!/usr/bin/env bash
# NOTE: This bash script is run also directly on host.

function taito::core::ci_enabled () {
  local enabled_phases=$1
  local phase=$2
  local default_value=$3
  if [[ ${enabled_phases} ]] &&
     [[ ${enabled_phases,,} != *"phases"* ]] &&  # Azure DevOps workaround
     [[ " ${enabled_phases} " != *"${phase}"* ]]
  then
    echo "false"
  else
    echo "${default_value:-true}"
  fi
}

function taito::core::export_project_config () {
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

  # For backwards compatibility
  # TODO: remove these
  if [[ ${taito_targets} ]]; then
    if [[ -z ${taito_containers+x} ]]; then
      export taito_containers
      taito_containers=$(taito::print_targets_of_type_deprecated container)
    fi
    if [[ -z ${taito_functions+x} ]]; then
      export taito_functions
      taito_functions=$(taito::print_targets_of_type_deprecated "function")
    fi
    if [[ -z ${taito_databases+x} ]]; then
      export taito_databases
      taito_databases=$(taito::print_targets_of_type_deprecated database)
    fi
    if [[ -z ${taito_buckets+x} ]]; then
      export taito_buckets
      taito_buckets=$(taito::print_targets_of_type_deprecated storage)
    fi
  fi

  # Set defaults
  local export_defaults=
  for bucket in ${taito_buckets[@]}; do
    export_defaults="
      ${export_defaults}
      export st_${bucket}_class=\${st_${bucket}_class:-\$taito_default_storage_class}
      export st_${bucket}_location=\${st_${bucket}_location:-\$taito_default_storage_location}
      export st_${bucket}_days=\${st_${bucket}_days:-\$taito_default_storage_days}
      export st_${bucket}_backup_location=\${st_${bucket}_days:-\$taito_default_storage_backup_location}
      export st_${bucket}_backup_days=\${st_${bucket}_days:-\$taito_default_storage_backup_days}
    "
  done
  eval "${export_defaults}"

  if [[ -z ${taito_targets} ]]; then
    export taito_targets=
    taito_targets=$(echo "${taito_containers:-} ${taito_functions:-} ${taito_static_contents:-} ${taito_databases:-}" | tr ' ' '\n' | sort | uniq | xargs)
  fi

  # Set ci flags depending on phase
  export ci_exec_build
  ci_exec_build=$(taito::core::ci_enabled "${taito_ci_phases:-}" "build" "${ci_exec_build}")
  export ci_exec_deploy
  ci_exec_deploy=$(taito::core::ci_enabled "${taito_ci_phases:-}" "deploy" "${ci_exec_deploy}")
  export ci_exec_test
  ci_exec_test=$(taito::core::ci_enabled "${taito_ci_phases:-}" "test" "${ci_exec_test}")
  export ci_exec_release
  ci_exec_release=$(taito::core::ci_enabled "${taito_ci_phases:-}" "release" "${ci_exec_release}")
}

function taito::core::export_user_config () {
  export taito_env="${1:-$taito_env}"
  export taito_target_env="${taito_target_env:-$taito_env}"

  # Default configuration
  if [[ -f "${taito_home_path}/.taito/taito-config.sh" ]]; then
    set -a
    # shellcheck disable=SC1090
    . "${taito_home_path}/.taito/taito-config.sh"
    set +a
  fi

  # Organization specific configuration
  org_config_file=""
  if [[ ${taito_organization_param:-} ]]; then
    org_config_file="${taito_home_path}/.taito/taito-config-${taito_organization_param}.sh"
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
}

function taito::core::print_command_with_internal_syntax () {
  args=("$@")

  # Convert space syntax to internal hyphen syntax
  if [[ ${args[0]} != *"-"* ]]; then
    space_cmd=()
    space_args=()
    mark_found="false"
    for arg in "${args[@]}"
    do
      if [[ ! ${arg} =~ ^[a-zA-Z][0-9a-zA-Z:]+$ ]] ||
         [[ ${mark_found} == "true" ]]; then
        mark_found="true"
        space_args+=("${arg}")
      elif [[ ${arg} == *":"* ]] && [[ ${mark_found} == "false" ]]; then
        mark_found="true"
        space_cmd+=("${arg}")
      elif [[ ${mark_found} == "false" ]]; then
        space_cmd+=("${arg}")
      fi
    done
    space_cmd="${space_cmd[@]}"
    args=("${space_cmd// /-}" "${space_args[@]}")
  fi

  printf "%s\\n" "${args[@]}"
}

# Resolve project root folder by the location of taito-config.sh
function taito::core::print_project_path () {
  current_path="${PWD}"
  while [[ ${PWD} != "/" ]]; do
    ls | grep taito-config.sh > /dev/null && break; cd ..;
  done
  if [[ ${PWD} != "/" ]]; then
    echo "${PWD}"
  else
    echo "${current_path}"
  fi
}

function taito::core::sort_commands_by_priority () {
  tr ' ' '\n' | sed 's/^\(.*\)\(..\)$/\2\1\2/' | sort | sed 's/^..\(.*\)$/\1/'
}

function taito::core::upgrade () {
  set +e
  # Make sure that mounted directories exist
  echo "Checking mount directories"
  mkdir -p "${taito_home_path}/.taito"
  mkdir -p "${taito_home_path}/.ssh"
  mkdir -p "${taito_home_path}/.terraform.d"

  # Pull latest version of taito bash script
  echo "Pulling taito-cli directory from git: ${taito_cli_path}"
  (
    cd "${taito_cli_path}"
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    if [[ ${branch} != "master" ]]; then
      echo
      echo "WARNING! You are currently using ${branch} branch of taito-cli."
      if taito::confirm "Checkout the master branch instead?"; then
        git checkout master
        git branch --set-upstream-to=origin/master master
      fi
    fi
    git pull
  )

  # Pull taito-cli docker image
  echo "Pulling taito-cli docker image from registry: ${taito_image}"
  docker pull "${taito_image}"

  # Prepare taito-new image for modificaions
  docker rm taito-save taito-new &> /dev/null

  echo "Creating taito user with local user uid and gid on taito-cli image"
  docker_run_flags=
  if [[ -f ${HOME}/.taito/install ]]; then
    docker_run_flags="-v ${HOME}/.taito/install:/taitoinstall"
  fi
  # TODO: remove .sh extension
  ${winpty} docker run -it --name taito-new \
    --entrypoint ${winptyprefix:-}/bin/bash \
    ${docker_run_flags} "${taito_image}" -c "
      /taito-cli-deps/tools/user-create.sh taito $(id -u) $(id -g)
      /taito-cli-deps/tools/user-init.sh taito
      if [[ -f /taitoinstall ]]; then
        echo
        echo --- Executing \~/.taito/install ---
        echo
        chmod +x /taitoinstall
        /taitoinstall
        echo
        echo --- Done executing \~/.taito/install ---
        echo
      fi
  "

  # Copy credentials from old image
  if docker create --name taito-save "${taito_image}save" &> /dev/null; then
    echo "Copying settings from the old taito-cli image"
    rm -rf ~/.taito/save &> /dev/null
    mkdir -p ~/.taito/save &> /dev/null

    docker cp taito-save:/home/taito ~/.taito/save &> /dev/null
    docker cp taito-save:/root ~/.taito/save &> /dev/null

    # a quick fix to preserve repositories installed in user-init
    rm -f ~/.taito/save/taito/.helm/repository/repositories.yaml
    rm -f ~/.taito/save/root/.helm/repository/repositories.yaml

    docker cp ~/.taito/save/taito taito-new:/home &> /dev/null
    docker cp ~/.taito/save/root taito-new:/ &> /dev/null

    rm -rf ~/.taito/save
  fi

  echo "Committing changes to taito-cli image"
  docker commit taito-new "${taito_image}" &> /dev/null
  docker stop taito-new &> /dev/null
  docker image tag "${taito_image}" "${taito_image}save"
  docker rm taito-save taito-new &> /dev/null

  echo "Deleting old temp files"
  rm -rf "${taito_home_path}/.taito/tmp" &> /dev/null

  echo
  echo "DONE! Your taito-cli has been upgraded."
  echo
  echo "NOTE: It is recommended that once in while you also check that your"
  echo "taito settings are up-to-date. They are located at '~/.taito'"
  echo "directory. You may find the recommended settings by running"
  echo "'taito open conventions' or 'taito -o ORGANIZATION open conventions'."
  echo
  set -e
}
