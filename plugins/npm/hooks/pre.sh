#!/bin/bash

: "${taito_skip_override:?}"
: "${taito_command_exists:?}"
: "${taito_command:?}"
: "${taito_env:?}"

command_short="${taito_command#oper-}"
exit_code=0

suffix=" ${*}"
suffix="${suffix/--/}"
suffix="${suffix/  /:}"
suffix="${suffix/ /:}"
if [[ "${suffix}" == ":" ]]; then
  suffix=""
fi

if [[ -f "./package.json" ]]; then
  # Read command names from package.json
  commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')

  if [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}:${taito_env}${suffix}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${taito_command}:${taito_env}${suffix}"
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${suffix}$") != "" ]]; then
    # Use overriding command from package.json without enviroment suffix
    npm_command="taito-${taito_command}${suffix}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${taito_command}:${taito_env}${suffix}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${taito_command}:${taito_env}${suffix}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${taito_command}${suffix}$") != "" ]]; then
    # Use normal command from package.json without enviroment suffix
    npm_command="${taito_command}${suffix}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${command_short}:${taito_env}${suffix}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${command_short}:${taito_env}${suffix}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${command_short}${suffix}$") != "" ]]; then
    # Use normal command from package.json without enviroment suffix
    npm_command="${command_short}${suffix}"
  fi

  if [[ "${npm_command}" != "" ]]; then
    # Run it
    echo
    echo "### npm/pre: Running script '${npm_command}'"
    # NOTE: intentionally removed parameter support: -- "${@}"
    if ! npm run -s "${npm_command}"; then
      exit_code=1
    else
      exit_code=66
    fi
  fi
fi

exit ${exit_code}
