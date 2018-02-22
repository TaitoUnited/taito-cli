#!/bin/bash
# NOTE: This bash script is run inside docker container.

# TODO REFACTOR: clean this mess up a bit

# Parse options
skip_override=false
skip_rest=false
args=()
while [[ $# -gt 0 ]]
do
  key="$1"
  if [[ ${skip_rest} == false ]]; then
    case $key in
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
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${skip_override}" == false ]]; then
  echo "Taito-cli Copyright (C) 2017 Taito United"
  echo "This program comes with ABSOLUTELY NO WARRANTY; for details see the LICENSE."
fi

# Convert space command syntax to internal hyphen syntax
# TODO
# args=($("${taito_src_path}/convert-command-syntax.sh" ${args[@]})) && \

# Determine command, env and parameters from args
env_command="${args[0]}"
params=(${args[@]:1})
if [[ "${env_command}" == *":"* ]]; then
  command=${env_command%:*}
  env=${env_command##*:}
elif [[ -z "${env_command}" ]]; then
  env_command="--help"
else
  command=${env_command}
fi

# Use 'oper-' as a default command prefix
orig_command=${command}
if [[ "${command}" != *"-"* ]]; then
  command="oper-${command}"
fi

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
export taito_env="${env}"
export taito_branch="${branch}"

if [[ " oper-unit oper-scan oper-docs ci-publish " == *"${taito_command}"* ]] && \
   [[ -f ./taitoflag_images_exist ]]; then
  echo
  echo "### Skipping ${taito_command}. Image already exists."
  echo
  exit 0
fi

# Read taito-config.sh files from all locations
. "${taito_util_path}/read-taito-config.sh" "${taito_env}" && \

# Read taito-secrets.sh in case of CI/CD
if [[ -f ${taito_project_path}/taito-secrets.sh ]]; then
  # Taito secrets for CI/CD
  # shellcheck disable=SC1091
  . ${taito_project_path}/taito-secrets.sh
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
  echo
  eval "${params[@]}"
  exit_code=${?}
else
  # Execute taito-cli command

  # Call pre-handers
  for handler in "${pre_handlers[@]}"
  do
    # shellcheck disable=SC1090
    . "${taito_cli_path}/util/set-taito-plugin-path.sh" "${handler%hooks\/*}"
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
      "${taito_cli_path}/util/call-next.sh" "${params[@]}"
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
        export taito_plugin_path="${taito_cli_path}/plugins/basic"
        "${taito_cli_path}/plugins/basic/__help.sh" "${orig_command}"
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
    . "${taito_cli_path}/util/set-taito-plugin-path.sh" "${handler%hooks\/*}"
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
