#!/bin/bash
# NOTE: This bash script is run inside docker container.

# Parse options
verbose=false
continue=false
skip_override=false
skip_rest=false
args=()
while [[ $# -gt 0 ]]
do
  key="$1"
  if [[ ${skip_rest} == false ]]; then
    case $key in
        -c|--continue)
        continue=true
        shift
        ;;
        -v|--verbose)
        verbose=true
        shift
        ;;
        -z)
        skip_override=true
        shift
        ;;
        *)
        # not known -> pass it to the command
        args+=("$1")
        shift
        if [[ "$1" != "-"* ]]; then
          # not an option -> pass all the rest to the command
          skip_rest=true
        fi
        ;;
    esac
  else
    # Add to args to be passed for the command
    args+=("$1")
    shift
  fi
done

# CI/CD runs taito_impl directly so we need to print this here also
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${continue}" == "false" ]]; then
  echo "Taito-cli Copyright (C) 2017 Taito United"
  echo "This program comes with ABSOLUTELY NO WARRANTY; for details see the LICENSE."
fi

# Convert space command syntax to internal hyphen syntax
# TODO
# args=($("${taito_src_path}/convert-command-syntax.sh" ${args[@]}))

# Determine command, target, env and parameters from args
env_command="${args[0]}"
params=(${args[@]:1})
if [[ "${env_command}" == *":"* ]]; then
  IFS=':' read -ra ADDR <<< "${env_command}"
  for sect in "${ADDR[@]}"; do
    if [[ -z "${command}" ]]; then
      command="${sect}"
    elif [[ " local feature dev test staging prod master " == *" ${sect} "* ]]; then
      env="${sect}"
    else
      target="${sect}"
    fi
  done
elif [[ -z "${env_command}" ]]; then
  env_command="--help"
else
  command=${env_command}
fi

# TODO can be removed? was used for oper-
orig_command=${command}

# TODO clean up code below

# Determine env
if [[ "${env}" == "" ]]; then
  # Env not given. Using local as default.
  env="local"
fi
if [[ "${env}" == "master" ]]; then
  # branch name given instead of env
  env="prod"
elif [[ "${env}" == "f"* ]]; then
  # branch name given instead of env
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

# Export some variables to be used in configs and command execution
export taito_skip_override="${skip_override}"
export taito_command="${command}"
export taito_orig_command="${orig_command}"
export taito_env="${env}"
export taito_branch="${branch}"
export taito_target="${target}"
export taito_verbose=false
export taito_setv=":"
export taito_vout="/dev/null"
if [[ ${verbose} == true ]]; then
  # Helper environment variables to be used in verbose mode
  taito_verbose=true
  taito_setv="set -x"
  taito_vout="/dev/stdout"

  echo taito_command: "${taito_command}"
  echo taito_target: "${taito_target}"
  echo taito_env: "${taito_env}"
fi

if [[ " unit scan docs ci-publish " == *"${taito_command}"* ]] && \
   [[ -f ./taitoflag_images_exist ]]; then
  echo
  echo "### Skipping ${taito_command}. Image already exists."
  echo
  exit 0
fi

# Read taito-config.sh files from all locations
. "${taito_util_path}/read-taito-config.sh" "${taito_env}" && \

# Select database configs using taito_target
. "${taito_util_path}/read-database-config.sh" && \

# Read taito-secrets.sh in case of CI/CD
if [[ -f ${taito_project_path}/taito-secrets.sh ]]; then
  # Taito secrets for CI/CD
  # shellcheck disable=SC1091
  . ${taito_project_path}/taito-secrets.sh
fi

# TODO remove: for backwards compatibility
export taito_company="${taito_company:-$taito_customer}"
if [[ -n "${postgres_name:-}" ]]; then
  export database_instance="${postgres_name:-}"
  export database_name="${postgres_database:-}"
  export database_host="${postgres_host:-}"
  export database_port="${postgres_port:-}"
fi

# TODO ^^^^^ clean up code ^^^^^


# Validate env
if [[ "${taito_env}" != "local" ]] && \
   [[ " ${taito_environments:-} " != *" ${taito_env} "* ]]; then
  echo
  echo "ERROR: '${taito_env}' not included in taito_environments: ${taito_environments:-}"
  exit 1
fi

# Confirm prod operations
if [[ "${taito_env}" == "prod" ]] && \
   [[ "${taito_command}" != "info" ]] && \
   [[ "${taito_command}" != "status" ]] && \
   [[ "${taito_command}" != "logs" ]] && \
   [[ "${taito_command}" != "open-"* ]] && \
   [[ "${taito_mode:-}" != "ci" ]]; then
  echo
  echo "The operation is targetting prod environment. Do you want to continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
    exit 130
  fi

  # Confirm suspicious operations
  if [[ "${taito_command}" == "init" ]]; then
    echo
    echo "Command '${orig_command}' is not meant to be run on production environment"
    echo "Do you want to continue anyway (Y/n)?"
    read -r confirm
    if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
      exit 130
    fi
  fi
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
plugins_string=$(echo "${taito_plugins:-}" "${taito_global_plugins:-} basic " \
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
extensions=("${taito_enabled_extensions} ${taito_cli_path}/plugins")
# TODO plugin_path??
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

    pre_command_chain+=($(printf '%s\n' "${commands[@]}" | grep "#pre\."))
    command_chain+=($(printf '%s\n' "${commands[@]}" | grep -v "#\|\.txt\|\.md" ))
    post_command_chain+=($(printf '%s\n' "${commands[@]}" | grep "#post\."))
  fi
done

# Assemble the final taito command chain
concat_full_chain=(
  "${pre_handlers[@]}"
  "${pre_command_chain[@]}"
  "${command_chain[@]}"
  "${post_command_chain[@]}"
  "${post_handlers[@]}"
)
concat_commands_only_chain=(
  "${pre_command_chain[@]}"
  "${command_chain[@]}"
  "${post_command_chain[@]}"
)

# Export some variables to be used in command execution
export taito_command_chain="${concat_full_chain[@]}"
export taito_original_command_chain="${concat_full_chain[@]}"
export taito_commands_only_chain="${concat_commands_only_chain[@]}"
export taito_enabled_plugins="${enabled_plugins}"

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

# Execute command
exit_code=0
if [[ "${command}" == "__shell" ]]; then
  # Start interactive shell
  /bin/bash
  exit_code=${?}
elif [[ "${command}" == "__" ]]; then
  # Execute shell command given as argument
  echo
  eval "${params[@]}"
  exit_code=${?}
else
  # Print some additional info in verbose mode
  if [[ ${verbose} == true ]]; then
    echo
    echo "### Taito-cli: Executing on ${taito_namespace:-} environment:"
    echo -e "${taito_command_chain// /\\n}"
  fi

  # Execute taito-cli command chain
  "${taito_cli_path}/util/call-next.sh" "${params[@]}"
  exit_code=${?}
  if [[ ${exit_code} == 130 ]]; then
    echo "Cancelled"
  elif [[ ${exit_code} -gt 0 ]]; then
    echo "ERROR! Command failed."
  fi
fi

# Admin credentials post-handling (just in case)
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
