#!/bin/bash -e
# NOTE: This bash script is run inside docker container.

# Parse options
verbose="${taito_verbose:-false}"
debug="${taito_debug:-false}"
quiet="${taito_quiet:-false}"
continue="${taito_continue:-false}"
skip_override=false
skip_rest=false
args=()
while [[ $# -gt 0 ]]
do
  key="$1"
  if [[ ${skip_rest} == false ]]; then
    case $key in
        --version)
        echo "TODO: print Taito CLI version"
        exit
        ;;
        --check)
        if [[ $(whoami) == "taito" ]]; then
          echo
          echo "Taito CLI is OK!"
          exit
        else
          echo
          echo "ERROR: 'taito' user has not been initialized properly."
          echo
          echo "Run 'taito upgrade'."
          exit 1
        fi
        ;;
        -c|--continue)
        continue=true
        shift
        ;;
        -v|--verbose)
        verbose=true
        shift
        ;;
        -q|--quiet)
        quiet=true
        shift
        ;;
        --debug)
        verbose=true
        debug=true
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

# TODO Convert space command syntax to internal hyphen syntax

# Determine command, target, env and parameters from args
env_command="${args[0]}"
env_command="${env_command,,}"
params=("${args[@]:1}")
if [[ "${env_command}" == *":"* ]]; then
  IFS=':' read -ra ADDR <<< "${env_command}"
  for sect in "${ADDR[@]}"; do
    if [[ -z "${command}" ]]; then
      command="${sect}"
    # TODO: Remove hardcoded envs. They are currently required because
    # taito-config.sh has not been read yet at this point of execution
    elif [[ -z "${env}" ]] && ( \
         [[ " local dev test stag staging cana canary prod master " == *" ${sect} "* ]] || \
         [[ "${sect}" == "feat-"* ]] ); then
      env="${sect}"
    elif [[ -z "${dest_env}" ]] && ( \
         [[ " local dev test stag staging cana canary prod master " == *" ${sect} "* ]] || \
         [[ "${sect}" == "feat-"* ]] ); then
      dest_env="${sect}"
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
fi
if [[ "${dest_env}" == "master" ]]; then
  # branch name given instead of env
  dest_env="prod"
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
export taito_default_password="${taito_default_password:-secret}"
export taito_continue="true"
export taito_skip_override="${skip_override}"
export taito_command="${command}"
export taito_orig_command="${orig_command}"
export taito_env="${env}"
export taito_dest_env="${dest_env}"
export taito_target_env="${env}"
export taito_target="${target}"
export taito_verbose=false
export taito_debug=false
export taito_quiet=${quiet}
export taito_setv=":"
export taito_vout="/dev/null" # verbode mode output
export taito_dout="/dev/null" # debug mode output
if [[ ${verbose} == true ]]; then
  # Helper environment variables to be used in verbose mode
  taito_verbose=true
  taito_setv="set -x"
  taito_vout="/dev/stdout"
fi

if [[ ${taito_mode} == "ci" ]]; then
  echo "[${taito_command}]"
fi

if [[ ${debug} == true ]]; then
  taito_debug=true
  echo taito_command: "${taito_command}"
  echo taito_target: "${taito_target}"
  echo taito_env: "${taito_env}"
fi

# NOTE: ci-publish is deprecated
if [[ " unit scan docs ci-publish artifact-publish build-publish " == *"${taito_command}"* ]] && \
   [[ -f ./taitoflag_images_exist ]]; then
  echo
  echo "Skipping ${taito_command}. Image already exists."
  echo
  exit 0
fi

if [[ "${taito_command}" == "test" ]] && \
   [[ "${taito_mode:-}" == "ci" ]] && \
   [[ "${ci_exec_test:-}" != "true" ]]; then
  echo
  echo "Skipping ${taito_command} in ci mode. ci_exec_test is false."
  echo
  exit 0
fi

# Set defaults
# TODO set default taito_version here

if [[ ${TAITO_CONFIG_OVERRIDE} == *"://"* ]]; then
  mkdir -p "${taito_project_path}/tmp" &> /dev/null
  wget -O "${taito_project_path}/tmp/taito-config-override.sh" "${TAITO_CONFIG_OVERRIDE}" &> /dev/null
  export TAITO_CONFIG_OVERRIDE=${taito_project_path}/tmp/taito-config-override.sh
fi

# Read taito-config.sh files from all locations
. "${taito_util_path}/read-user-taito-config.sh" "${taito_env}" && \
. "${taito_util_path}/read-project-taito-config.sh" "${taito_env}" && \

# Set output formatting
export H1s="${taito_style_h1_s:-\\e[92m\\e[1m[}" # Heading 1 start: Light green, bold
export H1e="${taito_style_h1_e:-]\\e[0m}"        # Heading 1 end
export H2s="${taito_style_h2_s:-\\e[95m[}"       # Heading 2 start: Light magenta
export H2e="${taito_style_h2_e:-]\\e[0m}"        # Heading 2 end
export NOTEs="${taito_style_note_s:-\\e[104m[}"  # Note start: Ligth blue background
export NOTEe="${taito_style_note_e:-]\\e[0m}"    # Note end

# For backwards compatibility --> TODO remove!
if [[ ! "${taito_version}" ]]; then
  if [[ "${taito_secrets}" == *"git.github.build"* ]]; then
    export taito_version="0"
  else
    export taito_version="1"
  fi
fi

# Concatenate all secrets
if [[ "${taito_env}" != "local" ]]; then
  export taito_secrets="${taito_secrets} ${taito_remote_secrets:-}"
fi

# Determine branch
branch="${taito_env}"
if [[ "${branch}" == "prod" ]]; then
  branch="master"
elif [[ "${branch}" == "local" ]]; then
  branch=""
fi
export taito_branch="${branch}"

# Execute some additional check only once in a while
if (( RANDOM % 4 == 0 )) && \
   [[ "${taito_mode:-}" != "ci" ]] && \
   [[ ${quiet} != "true" ]] && \
   [[ ${taito_command} != "project-"* ]] && \
   [[ ${taito_command} != "env-apply" ]]; then
  if [[ $(grep "\\* \\[ \\] All done" CONFIGURATION.md 2> /dev/null || :) != "" ]]; then
    echo
    echo "--------------------------------------------------------"
    echo "NOTE: This project has not yet been fully configured."
    echo "See the '[ ] All done' checkboxes in CONFIGURATION.md."
    echo "--------------------------------------------------------"
  fi
fi

# Validate args
if [[ " local ${taito_environments:-} " != *" ${taito_target_env} "* ]]; then
  echo
  echo "ERROR: Unknown environment '${taito_target_env}'"
  echo "Valid environments: local ${taito_environments}"
  exit 1
fi
if [[ " local ${taito_environments:-} " != *" ${taito_env} "* ]]; then
  echo
  echo "ERROR: Unknown environment '${taito_env}'"
  echo "Valid environments: local ${taito_environments}"
  exit 1
fi
if [[ ${taito_target} ]] && \
   [[ "${taito_mode:-}" != "ci" ]] && \
   [[ "${taito_targets:-}" != *"${taito_target}"* ]] && \
   [[ "${taito_build_targets:-}" != *"${taito_target}"* ]]; then
  echo
  echo "ERROR: Unknown target '${taito_target}'"
  echo
  echo "Valid environments: local ${taito_environments}"
  echo "Valid targets: ${taito_targets}"
  echo "Valid build targets: ${taito_build_targets}"
  echo "Valid databases: $("$taito_util_path/get-targets-by-type.sh" database)"
  exit 1
fi

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

# TODO remove: for backwards compatibility
export kubectl_name=${kubectl_name:-$kubernetes_name}
export kubectl_replicas=${kubectl_replicas:-$kubernetes_replicas}
export kubectl_cluster=${kubectl_cluster:-$kubernetes_cluster}
export kubectl_user=${kubectl_user:-$kubernetes_user}
export kubernetes_name=${kubectl_name}
export kubernetes_replicas=${kubectl_replicas}
export kubernetes_cluster=${kubectl_cluster}
export kubernetes_user=${kubectl_user}
export gcloud_project=${gcloud_project:-$taito_zone}
export gcloud_region=${gcloud_region:-$taito_provider_region}
export gcloud_zone=${gcloud_zone:-$taito_provider_zone}
export taito_provider_org_id=${taito_provider_org_id:-$gcloud_org_id}
export taito_provider_region=${taito_provider_region:-$gcloud_region}
export taito_provider_zone=${taito_provider_zone:-$gcloud_zone}
export taito_container_registry=${taito_container_registry:-$taito_image_registry}

# TODO ^^^^^ clean up code ^^^^^


# Validate env
if [[ "${taito_env}" != "local" ]] && \
   [[ " ${taito_environments:-} " != *" ${taito_env} "* ]]; then
  echo
  echo "ERROR: '${taito_env}' not included in taito_environments: ${taito_environments:-}"
  exit 1
fi

# Validate auth operations
if [[ "${taito_command}" == "auth" ]] && \
   [[ "${taito_env}" == "local" ]] && \
   [[ "${taito_type:-}" != "zone" ]]; then
  echo
  echo "ERROR: You cannot authenticate to local environment."
  echo "Specify environment: taito auth:ENV".
  exit 130
fi

# Validate env operations
if [[ "${taito_command}" == "env-apply" ]] && [[ -z "${taito_domain:-}" ]] && \
   grep -q taito_domain taito-config.sh; then
  echo
  echo "ERROR: taito_domain has not been set for ${taito_target_env} environment."
  echo "Configure DNS and set taito_domain for ${taito_target_env} environment"
  echo "in taito-config.sh. The default IP address for this zone is shown below."
  echo "You can use it as IP address if unique IP address is not required."
  echo
  getent hosts "${taito_default_domain:-}" | awk '{ print $1 }'
  exit 130
fi

if [[ "${taito_command}" == "env" ]] && [[ "${taito_env}" == "local" ]]; then
  echo "ERROR: You cannot use the 'local' env with the env command."
  exit 1
fi

# Validate old --upgrade
if [[ "${taito_command}" == "__upgrade" ]]; then
  echo
  echo "NOTE: 'taito --upgrade' is no longer. Run 'taito upgrade'."
  exit 130
fi

# Validate old --auth
if [[ "${taito_command}" == "__auth" ]]; then
  echo
  echo "NOTE: 'taito --auth' is no longer. Run 'taito auth:ENV'."
  exit 130
fi

# Validate vc operations
if [[ "${taito_command}" == "vc-"* ]]; then
  echo
  echo "NOTE: 'taito vc' commands have been removed. See help:"
  echo "$ taito env -h"
  echo "$ taito feat -h"
  echo "$ taito commit -h"
  exit 130
fi

# Validate zone operations
if [[ "${taito_command}" == "zone-"* ]] && \
   [[ "${taito_command}" != "zone-create" ]] && \
   [[ "${taito_type:-}" != "zone" ]]; then
  echo
  echo "ERROR: You can run zone commands only inside a zone directory."
  exit 130
fi

# Confirm zone operations
if [[ "${taito_command}" == "zone-"* ]] && \
   [[ "${taito_command}" != "zone-create" ]] && \
   [[ "${taito_command}" != "zone-status" ]] && \
   [[ ${quiet} != "true" ]]; then
  echo
  echo "The operation is targetting zone ${taito_zone:-}."
  "$taito_util_path/confirm.sh"
fi

# Confirm prod operations
if ( [[ "${taito_env}" == "prod" ]] || [[ "${taito_dest_env}" == "prod" ]] ) && \
   [[ "${taito_command}" != "info" ]] && \
   [[ "${taito_command}" != "status" ]] && \
   [[ "${taito_command}" != "logs" ]] && \
   [[ "${taito_command}" != "open-"* ]] && \
   [[ "${taito_mode:-}" != "ci" ]] && \
   [[ ${quiet} != "true" ]]; then
  echo
  echo "The operation is targetting prod environment of ${taito_project:-}."
  "$taito_util_path/confirm.sh" "Do you want to continue anyway?" no

  # Confirm suspicious operations
  if [[ "${taito_command}" == "init" ]]; then
    echo
    echo "Command 'taito ${orig_command}' is not meant to be run on production environment."
    "$taito_util_path/confirm.sh" "Do you want to continue anyway?" no
  fi
fi

# Confirm env-apply and env-destroy admin privileges
if [[ ${taito_command} == "env-apply" ]] || \
   [[ ${taito_command} == "env-destroy" ]]; then
  if [[ $taito_target_env == "prod" ]] || \
     [[ $taito_target_env == "canary" ]] || \
     [[ $taito_target_env == "stag" ]]; then
    echo
    echo "Running 'taito ${taito_command//-/ }' on $taito_target_env environment most likely"
    echo "requires admin privileges. You may not be allowed to execute all operations."
    "$taito_util_path/confirm.sh" "Do you want to continue anyway?" no
  fi
fi

if [[ "${taito_command}" == "env-merge" ]]; then
  # Parse arguments
  dest=""
  for param in ${params[@]}
  do
    if [[ ${param} != "-"* ]] && [[ ! ${dest} ]]; then
      dest=${param/prod/master}
    else
      echo "ERROR: Invalid parameter ${param}"
      exit 1
    fi
    shift
  done

  # Determine valid merges
  merges=""
  prev_env=""
  for env in ${taito_environments}
  do
    env="${env/prod/master}"
    if [[ ${env} != "feat"* ]]; then
      if [[ ${prev_env} ]]; then
        merges="${merges} ${prev_env}->${env} "
      fi
      prev_env="${env}"
    fi
  done

  # Determine source branch
  source="${taito_branch:-}"
  if [[ ! "${source}" ]]; then
    # use current git branch as source
    source=$(git symbolic-ref --short HEAD)
  fi

  # Determine destination branch
  if [[ ! ${dest} ]]; then
    dest=$(echo "${merges}" | sed "s/.*${source}->\([^[:space:]]*\).*/\1/")
  fi

  # Validate arguments
  if [[ ! "${merges}" =~ .*${source}-.*\>${dest}.* ]]; then
    echo "Merging from ${source} to ${dest} is not allowed."
    echo "Changes must be merged from one environment to another in this order:"
    echo "${taito_environments}"
    exit 1
  fi

  export taito_env_merge_source="${source}"
  export taito_env_merge_dest="${dest}"
  export taito_env_merges="${merges}"
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

# NOTE: For backwards compatibility (plugins were renamed)
export taito_plugins="${taito_plugins// git / git-global }"
export taito_plugins="${taito_plugins// dev-secrets / default-secrets }"
export taito_plugins="${taito_plugins// gcloud-builder:-local / gcloud-builder:-local gcloud-ci:-local }"

# Determine enabled plugins
enabled_plugins=""
plugins_string=$(echo "${taito_plugins:-} ${taito_global_plugins:-} basic " \
  | awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}')
# TODO remove this (backwards compatibility)
plugins_string="${plugins_string/postgres /postgres-db }"
# TODO remove this (sqitch added for backwards compatibility)
if [[ "${plugins_string}" == *"postgres-db"* ]] && \
   [[ "${plugins_string}" != *"sqitch-db"* ]]; then
  plugins_string="sqitch-db ${plugins_string}"
fi
# Hack: move google-global to first because it modifies link urls
if [[ "${plugins_string}" == *" google-global "* ]]; then
  plugins_string="google-global ${plugins_string/ google-global / }"
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
# commands=($(ls "${plugin_path}/${command}"[\#.]* 2> /dev/null || :))
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
    # TODO: use 'find path -executable' instead of {sh,py,js,x}
    pre_handlers+=($(ls "${plugin_path}"/hooks/pre*{sh,py,js,x} 2> /dev/null || :))
    post_handlers+=($(ls "${plugin_path}"/hooks/post*{sh,py,js,x} 2> /dev/null || :))

    # Add matching commands to command chain
    commands=($(ls "${plugin_path}/${command}"[\#.]*{sh,py,js,x} 2> /dev/null || :))

    pre_command_chain+=($(printf '%s\n' "${commands[@]}" | grep "#pre\." || :))
    command_chain+=($(printf '%s\n' "${commands[@]}" | grep -v "#\|\.txt\|\.md" || :))
    post_command_chain+=($(printf '%s\n' "${commands[@]}" | grep "#post\." || :))
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

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || ( \
    [[ "${taito_command:-}" == "test" ]] &&
    [[ "${taito_plugins:-}" == *"gcloud-ci"* ]] &&
    [[ "${taito_mode:-}" == "ci" ]] \
  ); then
  export taito_requires_database_connection="true"
else
  export taito_requires_database_connection="false"
fi

# Admin credentials pre-handling
if [[ -n "${taito_admin_key}" ]]; then
  if [[ ${#taito_admin_key} -lt 16 ]]; then
    echo
    echo "ERROR: Encyption key must be at least 16 characters long"
    exit 1
  fi

  if [[ ! -f ~/admin_creds.enc ]] && [[ "${command}" != "auth" ]]; then
    echo
    echo "ERROR: Admin credentials file missing. Authenticate as admin first."
    exit 1
  fi

  # Move normal user credentials elsewehere
  mv ~/.config ~/.config_normal
  mv ~/.kube ~/.kube_normal

  if [[ "${command}" != "auth" ]]; then
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

# Harcoded command handling
if [[ "${command}" == "hours-add" ]] || [[ "${command}" == "hours-stop" ]]; then
  export taito_hours_description
  if [[ "${command}" == "hours-add" ]]; then
    taito_hours_description="${params[@]:2}"
  else
    taito_hours_description="${params[@]}"
  fi
  while [[ ! "${taito_hours_description}" ]]; do
    echo
    echo "Enter hour entry description:"
    read -r taito_hours_description
  done
fi

# Execute command
exit_code=0
if [[ "${command}" == "shell" ]] && \
   [[ -z ${taito_target} ]] && \
   [[ ${taito_env} == "local" ]]; then
  # Start interactive shell
  /bin/bash
  exit_code=${?}
elif [[ "${command}" == "__" ]]; then
  # Execute shell command given as argument
  echo
  eval "${params[@]}"
  exit_code=${?}
else
  # Print some additional info in debug mode
  if [[ ${debug} == true ]]; then
    echo
    echo "TAITO CLI: Executing on ${taito_namespace:-} environment:"
    echo -e "${taito_command_chain// /\\n}"
  fi

  # Execute taito-cli command chain
  "${taito_util_path}/ssh-agent.sh" "$taito_util_path/call-next.sh" "${params[@]}"
  # "${taito_util_path}/call-next.sh" "${params[@]}"
  exit_code=${?}
  if [[ ${exit_code} == 130 ]]; then
    echo "Cancelled"
  elif [[ ${exit_code} -gt 0 ]]; then
    echo "ERROR! Command failed."
  fi
fi

# Admin credentials post-handling (just in case)
# NOTE: In case of auth command this was already run before docker commit
if [[ -n "${taito_admin_key_orig}" ]] && [[ "${command}" != "auth" ]]; then
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
