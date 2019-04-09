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

  if [[ ${source_env} ]]; then
    echo
    echo "### default-secrets/pre: Reading default secret values from ${source_env} environment"

    taito secrets:${source_env} --save-as-taito-secrets &> /dev/null
    sed -i 's/^export /export default_/' "${taito_project_path}/taito-secrets.sh" &> /dev/null
    . "${taito_project_path}/taito-secrets.sh" &> /dev/null
    if [[ -f "${taito_project_path}/taito-secrets.sh" ]]; then
      echo "Secrets were read successfully"
    else
      echo "Read failed"
    fi
    rm -f "${taito_project_path}/taito-secrets.sh" &> /dev/null
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"