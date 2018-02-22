#!/bin/bash

# TODO split into multiple bash functions and re-use some code in taito

# Contain pwd change in a subshell
if ! (

  # Determine parameters
  if [[ "${1}" == "-z" ]]; then
    skip_override=true
    env_command="${2}"
    params=(${@:3})
  else
    skip_override=false
    env_command="${1}"
    params=(${@:2})
  fi

  # CI/CD runs taito_impl directly so we need to print this here
  if [[ "${taito_mode:-}" == "ci" ]] && [[ "${skip_override}" == false ]]; then
    echo "Taito-cli Copyright (C) 2017 Taito United"
    echo "This program comes with ABSOLUTELY NO WARRANTY; for details see the LICENSE."
  fi

  # Determine command and env from env_command given as argument
  if [[ "${env_command}" == *":"* ]]; then
    command=${env_command%:*}
    env=${env_command##*:}
  else
    command=${env_command}
  fi

  # Use 'oper-' as a default command prefix
  orig_command=${command}
  if [[ "${command}" != *"-"* ]]; then
    command="oper-${command}"
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
    params=(${orig_command})
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

  if [[ " oper-unit oper-scan oper-docs ci-publish " == *"${taito_command}"* ]] && \
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

  # TODO remove: for backwards compatibility
  if [[ -n "${postgres_name:-}" ]]; then
    export database_instance="${postgres_name:-}"
    export database_name="${postgres_database:-}"
    export database_host="${postgres_host:-}"
    export database_port="${postgres_port:-}"
  fi

  # Validate env
  if [[ "${taito_env}" != "local" ]] && [[ " ${taito_environments:-} " != *" ${taito_env} "* ]]; then
    echo
    echo "ERROR: '${taito_env}' not included in taito_environments: ${taito_environments:-}"
    exit 1
  fi

  # Confirm prod operation
  if [[ "${taito_env}" == "prod" ]] && [[ "${taito_mode:-}" != "ci" ]]; then
    echo
    echo "The operation is targetting prod environment. Do you want to continue (Y/n)?"
    read -r confirm
    if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
      exit 130
    fi
  fi

  # Use overwrites defined by caller
  # TODO this is a quick hack
  if [[ ${database_host_overwrite:-} != "" ]]; then
    export database_host=${database_host_overwrite}
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
  enabled_plugins=""
  plugins_string=$(echo basic "${taito_plugins:-}" "${taito_global_plugins:-}" \
    | awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}')
  # TODO remove this (backwards compatibility)
  plugins_string="${plugins_string/postgres /postgres-db }"
  # TODO remove this (sqitch added for backwards compatibility)
  if [[ "${plugins_string}" == *"postgres-db"* ]] && \
     [[ "${plugins_string}" != *"sqitch-db"* ]]; then
    plugins_string="sqitch-db ${plugins_string}"
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

  # TODO Print command chain in verbose mode
  # if [[ ${skip_override} == false ]] && \
  #    [[ ${command_exists} == true ]] && \
  #    [[ ${command} != "__"* ]]; then
  #   echo
  #   echo "### Taito-cli: Executing on ${taito_namespace:-} environment:"
  #   echo -e "${taito_command_chain// /\n}" | awk -F/ '{print $(NF-1)"\057"$(NF)}'
  # fi

  # Admin credentials pre-handling
  if [[ -n "${taito_admin_key}" ]]; then
    if [[ ${#taito_admin_key} -lt 16 ]]; then
      echo
      echo "ERROR: Encyption key must be at least 16 characters long"
      exit 1
    fi

    if [[ ! -f ~/admin_creds.enc ]] && [[ "${command}" != "__auth" ]]; then
      echo
      echo "ERROR: Admin credentials file missing. Authenticate as admin first."
      exit 1
    fi

    # Move normal user credentials elsewehere
    mv ~/.config ~/.config_normal
    mv ~/.kube ~/.kube_normal

    if [[ "${command}" != "__auth" ]]; then
      # Decrypt admin credentials
      # TODO use something else than openssl:
      # https://cryptosense.com/weak-key-derivation-in-openssl/
      if ! openssl aes-256-cbc -d -salt -in ~/admin_creds.enc \
        -out ~/admin_creds.tar.gz -pass env:taito_admin_key; then
        echo
        echo "ERROR: Decrypting admin credentials failed"
        exit 1
      fi
      (cd ~ && tar -xf admin_creds.tar.gz)
      rm -f ~/admin_creds.tar.gz
      echo
      echo "Decrypted admin credentials"
      echo "---------------- ADMIN START ----------------"
      echo
    fi

    # Hide admin key from plugins
    taito_admin_key_orig="${taito_admin_key}"
    export taito_admin_key="-"
    export taito_is_admin=true
  fi

  # Auth command pre-handling
  if [[ "${command}" == "__auth" ]]; then
    echo
    echo "- Deleting old credentials"
    rm -rf ~/.config ~/.kube
  fi

  # Control flow flags
  exit_code=0
  skip_commands=false

  if [[ "${command}" == "__shell" ]]; then
    # Start interactive shell
    /bin/bash
    exit_code=${?}
  elif [[ "${command}" == "__" ]]; then
    # Execute shell command given as argument
    eval "${params[@]}"
    exit_code=${?}
  else
    # Execute taito-cli command

    # Call pre-handers
    for handler in "${pre_handlers[@]}"
    do
      # shellcheck disable=SC1090
      . "${cli_path}/util/set-taito-plugin-path.sh" "${handler%hooks\/*}"
      "${handler}" "${params[@]}"
      ecode=${?}
      if [[ ${ecode} == 66 ]]; then
        # exit code 66: no error, but skip the following commands
        skip_commands=true
      elif [[ ${ecode} -gt 0 ]]; then
        >&2 echo ERROR!
        skip_commands=true
        exit_code=${ecode}
      fi
    done

    # Call command
    if [[ ${skip_commands} == false ]]; then
      if [[ ${command_exists} == true ]]; then
        # Call the first command on the command chain
        "${cli_path}/util/call-next.sh" "${params[@]}"
        exit_code=${?}
        if [[ ${exit_code} == 130 ]]; then
          echo "Cancelled"
        elif [[ ${exit_code} -gt 0 ]]; then
          echo "ERROR! Command failed."
        fi
      elif [[ "${command}" == "oper-init" ]]; then
        # None of the enabled plugins has implemented oper-init
        echo "Nothing to initialize"
      else
        # Command not found
        echo
        if [[ "${orig_command}" != " " ]]; then
          # Show matching commands
          echo "Unknown command: '${orig_command//-/ }'. Perhaps one of the following commands is the one"
          echo "you meant to run. Run 'taito -h' to get more help."
          export taito_command_chain=""
          export taito_plugin_path="${cli_path}/plugins/basic"
          "${cli_path}/plugins/basic/__help.sh" "${orig_command}"
        else
          echo "Unknown command"
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
      ecode=${?}
      if [[ ${ecode} -gt 0 ]] && [[ ${ecode} != 66 ]]; then
        >&2 echo ERROR!
        exit_code=${ecode}
      fi
    done
  fi

  # Admin post-handling (just in case)
  # NOTE: In case of auth command this was already run before docker commit
  if [[ -n "${taito_admin_key_orig}" ]] && [[ "${command}" != "__auth" ]]; then
    # Delete admin credentials
    rm -rf ~/.config ~/.kube
    # Move normal user credentials back
    mv ~/.config_normal ~/.config
    mv ~/.kube_normal ~/.kube
    echo
    echo "---------------- ADMIN END ----------------"
    echo "Normal user credentials restored"
  fi

  exit ${exit_code}

); then
  exit 1
fi
