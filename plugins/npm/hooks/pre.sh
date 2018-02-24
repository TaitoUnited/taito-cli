#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_skip_override:?}"
: "${taito_command_exists:?}"
: "${taito_command:?}"
: "${taito_env:?}"

export taito_hook_command_executed=${taito_hook_command_executed}

command_short="${taito_command#oper-}"
exit_code=0
skip_remaining_commands=false

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
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${suffix}$") != "" ]]; then
    # Use overriding command from package.json without enviroment suffix
    npm_command="taito-${taito_command}${suffix}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${command_short}:${taito_env}${suffix}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${command_short}:${taito_env}${suffix}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${command_short}${suffix}$") != "" ]]; then
    # Use overriding command from package.json without enviroment suffix
    npm_command="taito-${command_short}${suffix}"
    skip_remaining_commands=true
  elif [[ $(echo "${commands}" | grep "^${taito_command}:${taito_env}${suffix}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${taito_command}:${taito_env}${suffix}"
  elif [[ $(echo "${commands}" | grep "^${taito_command}${suffix}$") != "" ]]; then
    # Use normal command from package.json without enviroment suffix
    npm_command="${taito_command}${suffix}"
  elif [[ $(echo "${commands}" | grep "^${command_short}:${taito_env}${suffix}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${command_short}:${taito_env}${suffix}"
  elif [[ $(echo "${commands}" | grep "^${command_short}${suffix}$") != "" ]]; then
    # Use normal command from package.json without enviroment suffix
    npm_command="${command_short}${suffix}"
  fi

  if [[ "${npm_command}" != "" ]]; then
    # Run it
    echo
    echo "### npm/pre: Running script '${npm_command}'"
    # NOTE: intentionally removed parameter support: -- "${@}"
    taito_hook_command_executed=true
    (${taito_setv:?}; npm run -s "${npm_command}")
    exit_code=$?
  fi
fi

if [[ ${exit_code} != 0 ]]; then
  exit ${exit_code}
elif [[ ${skip_remaining_commands} == false ]]; then
  # Call next command on command chain
  "${taito_cli_path}/util/call-next.sh" "${@}"
fi
