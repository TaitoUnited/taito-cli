#!/bin/bash

# TODO split into multiple bash functions and re-use some code in taito

# Contain pwd change in a subshell
if ! (

  # Determine parameters
  if [[ "${1}" == "-s" ]]; then
    skip_override=true
    orig_command="${2}"
    params=(${@:3})
  else
    skip_override=false
    orig_command="${1}"
    params=(${@:2})
  fi

  # Determine command and env from orig_command given as argument
  if [[ "${orig_command}" == *":"* ]]; then
    command=${orig_command%:*}
    env=${orig_command##*:}
  else
    command=${orig_command}
  fi

  if [[ "${env}" == "" ]]; then
    # Env not given. Using local as default.
    env="local"
  fi

  # CI/CD may give branch name as argument instead of environment name
  if [[ "${env}" == "master" ]]; then
    env="prod"
  elif [[ "${env}" == "f"* ]]; then
    env="feature"
  fi

  # Branch is determined by the env
  branch="${env}"
  if [[ "${branch}" == "prod" ]]; then
    branch="master"
  elif [[ "${branch}" == "local" ]]; then
    branch=""
  fi

  # Handle 'taito -h'
  if [[ "${command}" == "-h" ]]; then
    command="--help"
  fi

  # Handle 'taito COMMAND --help'
  if [[ " ${params[@]} " == *" -h "* ]] || \
     [[ " ${params[@]} " == *" --help "* ]]; then
    params=(${command})
    command="--help"
  fi

  # Handle 'taito' without arguments
  if [[ -z "${command}" ]]; then
    command=" "
  fi

  # Replace -- with __ at the beginning to match command filename naming
  if [[ "${command}" == "--"* ]]; then
    command="__${command#--}"
  fi

  # Resolve project root folder by the location of taito-config.sh
  # Use the project root dir as working directory from now on...
  current_path="${PWD}"
  while [[ "${PWD}" != "/" ]]; do
    ls | grep taito-config.sh > /dev/null && break; cd ..;
  done
  if [[ ${PWD} == "/" ]]; then
    cd "${current_path}" || exit 1
  fi
  project_path="${PWD}"

  # Resolve location of taito-cli implementation
  source="${BASH_SOURCE[0]}"
  while [[ -h "${source}" ]]; do # resolve until the file is no longer a symlink
    dir="$( cd -P "$( dirname "${source}" )" && pwd )"
    source=$(readlink "${source}")
    # if $SOURCE was a relative symlink, we need to resolve it relative
    # to the path where the symlink file was located
    [[ "${source}" != /* ]] && source="${cli_path}/${source}"
  done
  dir_name=$(dirname "${source}")
  cli_path="$( cd -P "${dir_name}" && pwd )"

  # Export some variables to be used in configs and command execution
  export taito_skip_override="${skip_override}"
  export taito_command="${command}"
  export taito_env="${env}"
  export taito_branch="${branch}"
  export taito_project_path="${project_path}"
  export taito_cli_path="${cli_path}"
  export taito_current_path="${current_path}"

  if ([[ " ci-test-unit ci-scan ci-docs publish " == *"${taito_command}"* ]] || \
        [[ " ci-test-api:local ci-test-e2e:local " == *"${taito_command}:${taito_env}"* ]]) && \
     [[ -f ./taitoflag_images_exist ]]; then
    echo
    echo "### Skipping ${taito_command}. Image already exists."
    echo
    exit 0
  fi

  # Read taito-config.sh files from all locations
  if [[ -f "${HOME}/.taito/taito-config.sh" ]]; then
    # Personal config
    # shellcheck disable=SC1090
    . "${HOME}/.taito/taito-config.sh"
  fi
  if [[ -f ./taito-config.sh ]]; then
    # Project specific config
    # shellcheck disable=SC1091
    . ./taito-config.sh
  fi
  if [[ -f ./taito-secrets.sh ]]; then # In case CI/CD uses taito-secrets.sh
    # Taito secrets for CI/CD
    # shellcheck disable=SC1091
    . ./taito-secrets.sh
  fi

  # Use overwrites defined by caller
  # TODO this is a quick hack
  if [[ ${postgres_host_overwrite:-} != "" ]]; then
    export postgres_host=${postgres_host_overwrite}
  fi

  # Create environment variables for secrets
  secret_index=0
  export taito_secret_names=""
  secret_exports=""
  secrets=("${taito_secrets}")
  for secret in ${secrets[@]}
  do
    # NOTE: A quick fix to support the new naming convention in which
    # method is given as suffix, not prefix
    fix_suffix="${secret##*:}"
    fix_prefix="${secret%:*}"
    if [[ ${#fix_suffix} -lt ${#fix_prefix} ]]; then
      secret="${fix_suffix}:${fix_prefix}"
    fi

    # Create env var name by replacing illegal characters
    secret_suffix="${secret##*:}"
    secret_name="${secret_suffix%/*}"
    secret_name="${secret_name//_/-}"
    secret_method="${secret%:*}"
    if [[ "${secret_suffix}" == *"/"* ]]; then
      secret_namespace="${secret_suffix##*/}"
    else
      secret_namespace="${taito_namespace:?}"
    fi
    taito_secret_names="${taito_secret_names} ${secret_name}"
    secret_exports="${secret_exports}export \
      secret_name_${secret_index}='${secret_name}'; "
    secret_exports="${secret_exports}export \
      secret_method_${secret_index}='${secret_method}'; "
    secret_exports="${secret_exports}export \
      secret_namespace_${secret_index}='${secret_namespace}'; "
    secret_index=$((${secret_index}+1))
  done

  eval "$secret_exports"

  # Determine enabled plugins
  # TODO remove duplicate plugins
  enabled_plugins=""
  plugins_string=" ${taito_plugins:-} ${taito_global_plugins:-} "
  if [[ "${plugins_string}" != *"basic"* ]]; then
    # The basic plugin is always enabled
    plugins_string="basic ${plugins_string}"
  fi
  plugins=("${plugins_string}")

  # Find matching plugin commands and assemble chains
  pre_handlers=()
  post_handlers=()
  pre_command_chain=()
  command_chain=()
  post_command_chain=()
  extensions=("${taito_enabled_extensions} ${cli_path}/plugins")
  commands=($(ls "${plugin_path}/${command}"[:.]* 2> /dev/null))
  for plugin in ${plugins[@]}
  do
    # Check first if plugin is enabled for this environment:
    # e.g. docker:local kubectl:-local
    split=(${plugin//:/ })
    plugin_name=${split[0]}
    plugin_env=${split[1]}
    if [[ "${plugin_env}" == "" ]] \
       || [[ "${plugin_env}" == "${env}" ]] \
       || [[ "${plugin_env}" == -* ]] && [[ "${plugin_env}" != "-${env}" ]]; then
      # Plugin is enabled for this environment
      enabled_plugins="${enabled_plugins} ${plugin_name}"
      plugin_path=""
      for extension in ${extensions[@]}
      do
        if [[ -d ${extension}/${plugin_name} ]]; then
          plugin_path="${extension}/${plugin_name}"
          break
        fi
      done

      # Add pre/post handlers
      pre_handlers+=($(ls "${plugin_path}"/hooks/pre* 2> /dev/null))
      post_handlers+=($(ls "${plugin_path}"/hooks/post* 2> /dev/null))

      # Add matching commands to command chain
      commands=($(ls "${plugin_path}/${command}"[:.]* 2> /dev/null))

      pre_command_chain+=($(printf '%s\n' "${commands[@]}" | grep ":pre\."))
      command_chain+=($(printf '%s\n' "${commands[@]}" | grep -v ":\|\.txt\|\.md" ))
      post_command_chain+=($(printf '%s\n' "${commands[@]}" | grep ":post\."))
    fi
  done

  # Assemble the final taito command chain
  command_chain=(
    "${pre_command_chain[@]}" "${command_chain[@]}" "${post_command_chain[@]}"
  )

  # Check if command exists
  command_exists=true
  if [ ${#command_chain[@]} -eq 0 ]; then
    command_exists=false
  fi

  # Export some variables to be used in command execution
  export taito_command_exists="${command_exists}"
  export taito_command_chain="${command_chain[@]}"
  export taito_original_command_chain="${command_chain[@]}"
  export taito_enabled_plugins="${enabled_plugins}"

  # Print command chain
  if [[ ${skip_override} == false ]] && \
     [[ ${command_exists} == true ]] && \
     [[ ${command} != "__"* ]]; then
    echo "### Taito-cli: Executing on ${taito_customer:-}-${taito_env} environment: ###"
    echo -e "${taito_command_chain// /\n}" | awk -F/ '{print $(NF-1)"\057"$(NF)}'
  fi

  # Control flow flags
  exit_code=0
  skip_commands=false

  # Call pre-handers
  for handler in "${pre_handlers[@]}"
  do
    # shellcheck disable=SC1090
    . "${cli_path}/util/set-taito-plugin-path.sh" "${handler%hooks\/*}"
    "${handler}" "${params[@]}"
    ecode=${?}
    if [[ ${ecode} == 1 ]]; then
      >&2 echo ERROR!
      skip_commands=true
      exit_code=1
    elif [[ ${ecode} -gt 1 ]]; then
      skip_commands=true
    fi
  done

  if [[ ${skip_commands} == false ]]; then
    if [[ ${command_exists} == true ]]; then
      # Call first command of the command chain
      if ! "${cli_path}/util/call-next.sh" "${params[@]}"; then
         >&2 echo ERROR!
        exit_code=1
      fi
    elif [[ "${command}" == "o-init" ]]; then
      # Note of the plugins has implemented o-init
      echo "Nothing to initialize"
    else
      # Command not found
      echo "Unknown command: '${command}'. Did you specify the correct ENV?"
      echo "Some of the plugins might not be enabled in '${taito_env}' environment."

      # Show matching commands
      if [[ "${command}" != " " ]]; then
        echo "Perhaps one of the following commands is the one you meant to run."
        echo "Run 'taito --help' to get more help."
        export taito_plugin_path="${cli_path}/plugins/basic"
        "${cli_path}/plugins/basic/__help.sh" "${command}"

        # Call also help of link plugin as it defined commands dynamically
        # TODO This is a hack
        if [[ "${taito_enabled_plugins}" == *" link "* ]]; then
          "${cli_path}/plugins/link/__help.sh" "${command}"
        fi
      fi
      exit_code=1
    fi
  fi

  # Call post-handers
  for handler in "${post_handlers[@]}"
  do
    # shellcheck disable=SC1090
    . "${cli_path}/util/set-taito-plugin-path.sh" "${handler%hooks\/*}"
    "${handler}" "${params[@]}"
    if [[ ${?} == 1 ]]; then
      >&2 echo ERROR!
      exit_code=1
    fi
  done

  # echo
  # if [[ ${taito_skip_override} == false ]]; then
  #   echo "### taito-cli: DONE! ###"
  # fi
  # echo

  exit ${exit_code}

); then
  exit 1
fi
