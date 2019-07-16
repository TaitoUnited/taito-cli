#!/bin/bash -e

function default-secrets::fetch_default_secrets () {
  secret_defaults_already_exist=$(
    set -o posix; set | grep -q "default_secret_value_" || :
  )
  if [[ ! ${secret_defaults_already_exist} ]]; then
    source_env=
    case ${taito_env:?} in
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

    if [[ ${source_env} ]] && \
       [[ " ${taito_environments:-} "  == *" ${source_env} "* ]]
    then
      taito::print_plugin_title
      echo "Reading default secret values from ${source_env} environment..."
      rm -f "${taito_project_path:?}/taito-secrets" &> /dev/null || :
      taito_command_context="default-secrets" \
        taito -q secrets:${source_env} --save-as-taito-secrets

      sed -i 's/^export /export default_/' \
        "${taito_project_path}/taito-secrets" &> /dev/null || :
      . "${taito_project_path}/taito-secrets" &> /dev/null || :
      if [[ -f "${taito_project_path}/taito-secrets" ]]; then
        echo "Default values were read successfully"
      else
        echo "No default values found"
      fi
      rm -f "${taito_project_path}/taito-secrets" &> /dev/null || :
    fi
  fi
}
