#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

if ( [[ ${taito_command} == "env-apply" ]] || \
     [[ ${taito_command} == "env-rotate" ]] ) &&
    ! env | grep -q "default_secret_value_"; then

  source_env=
  case $taito_env in
    prod)
      source_env=stag
      ;;
    stag)
      source_env=prod
      ;;
    *)
      if [[ $taito_env != "dev" ]]; then
        source_env=dev
      fi
      ;;
  esac

  if [[ ${source_env} ]] && [[ " ${taito_environments:-} "  == *" ${source_env} "* ]]; then
    echo
    echo -e "${taito_command_context_prefix:-}${H1s}default-secrets${H1e}"
    echo "Reading default secret values from ${source_env} environment..."
    rm -f "${taito_project_path}/taito-secrets.sh" &> /dev/null
    taito_command_context="default-secrets" \
      taito -q secrets:${source_env} --save-as-taito-secrets

    sed -i 's/^export /export default_/' "${taito_project_path}/taito-secrets.sh" &> /dev/null
    . "${taito_project_path}/taito-secrets.sh" &> /dev/null
    if [[ -f "${taito_project_path}/taito-secrets.sh" ]]; then
      echo "Default values were read successfully"
    else
      echo "No default values found"
    fi
    rm -f "${taito_project_path}/taito-secrets.sh" &> /dev/null
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
