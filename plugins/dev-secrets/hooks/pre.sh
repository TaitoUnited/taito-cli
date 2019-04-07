#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

if [[ "dev stag prod" != *"${taito_env}"* ]] && ( \
     [[ "${taito_command}" == "env-apply" ]] || \
     [[ "${taito_command}" == "env-rotate" ]] \
  ); then
  echo
  echo "### kubectl/pre: Reading default secret values from dev environment"
  taito secrets:dev --save-as-taito-secrets &> /dev/null
  sed -i 's/^export /export default_/' "${taito_project_path}/taito-secrets.sh" &> /dev/null
  . "${taito_project_path}/taito-secrets.sh" &> /dev/null
  if [[ -f "${taito_project_path}/taito-secrets.sh" ]]; then
    echo "Secrets were read successfully"
  else
    echo "Read failed"
  fi
  rm -f "${taito_project_path}/taito-secrets.sh" &> /dev/null
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
