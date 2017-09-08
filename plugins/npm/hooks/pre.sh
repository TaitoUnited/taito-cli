#!/bin/bash

: "${taito_skip_override:?}"
: "${taito_command_exists:?}"
: "${taito_command:?}"
: "${taito_env:?}"

exit_code=0

if [[ -f "./package.json" ]] && \
   [[ ${taito_command} != "ci-test-api" ]] && \
   [[ ${taito_command} != "ci-test-e2e" ]]; then
  # Read command names from package.json
  commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')

  if [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}:${taito_env}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${taito_command}:${taito_env}"
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}$") != "" ]]; then
    # Use overriding command from package.json without enviroment suffix
    npm_command="taito-${taito_command}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${taito_command}:${taito_env}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${taito_command}:${taito_env}"
  elif [[ ${taito_command_exists} == false ]] && \
       [[ $(echo "${commands}" | grep "^${taito_command}$") != "" ]]; then
    # Use normal command from package.json without enviroment suffix
    npm_command="${taito_command}"
  fi

  if [[ "${npm_command}" != "" ]]; then
    # Run it
    echo
    echo "### npm - pre: Running npm script ${npm_command} ###"
    echo
    if ! npm run -s "${npm_command}" -- "${@}"; then
      exit_code=1
    else
      exit_code=2
    fi
  fi
fi

exit ${exit_code}
