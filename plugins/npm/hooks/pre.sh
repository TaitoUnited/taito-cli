#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_skip_override:?}"
: "${taito_command:?}"
: "${taito_env:?}"

export taito_hook_command_executed=${taito_hook_command_executed}

exit_code=0
skip_remaining_commands=false

# EXAMPLE: taito test:dev server -- suite user
# - command_short = "test"
# - target = "server"
# - env = "dev"
# - params = "suite user"
command_short="${taito_command#oper-}"

target=""
if [[ "${taito_target:-}" ]]; then
  target=":${taito_target}"
fi

params="${*}"
if [[ "${params:-}" ]]; then
  params=" -- ${params}"
fi

if [[ -f "./package.json" ]]; then
  # Read command names from package.json
  commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')

  if [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${target}:${taito_env}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${taito_command}${target}:${taito_env}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${target}$") != "" ]]; then
    # Use overriding command from package.json without enviroment target
    npm_command="taito-${taito_command}${target}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${command_short}${target}:${taito_env}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${command_short}${target}:${taito_env}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${command_short}${target}$") != "" ]]; then
    # Use overriding command from package.json without enviroment target
    npm_command="taito-${command_short}${target}"
    skip_remaining_commands=true
  elif [[ $(echo "${commands}" | grep "^${taito_command}${target}:${taito_env}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${taito_command}${target}:${taito_env}"
  elif [[ $(echo "${commands}" | grep "^${taito_command}${target}$") != "" ]]; then
    # Use normal command from package.json without enviroment target
    npm_command="${taito_command}${target}"
  elif [[ $(echo "${commands}" | grep "^${command_short}${target}:${taito_env}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${command_short}${target}:${taito_env}"
  elif [[ $(echo "${commands}" | grep "^${command_short}${target}$") != "" ]]; then
    # Use normal command from package.json without enviroment target
    npm_command="${command_short}${target}"
  fi

  # taito test prehandling

  running_ci_test=false
  if [[ "${taito_mode:-}" == "ci" ]] && \
     ( \
       [[ "${npm_command%%:*}" == "test" ]] ||
       [[ "${npm_command%%:*}" == "oper-test" ]] \
     ); then
     running_ci_test=true
  fi

  if [[ ${running_ci_test} == true ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
    echo "Skipping test because ci_exec_test != true"
    npm_command=""
    running_ci_test=false
    taito_hook_command_executed=true
  fi

  if [[ "${taito_command}" == "ci-release"* ]]; then
    echo "TODO: remove this ci-release skip hack"
    npm_command=""
  fi

  # run npm command

  if [[ "${npm_command}" != "" ]]; then
    # Run it
    echo
    echo "### npm/pre: Running script '${npm_command}${params}'"
    # NOTE: Intentionally removed parameter support: -- "${@}"
    # NOTE: All libs are installed using 'npm install' run on directly on host.
    #       Perhaps some npm scripts should also be run on host to avoid
    #       compatibilty issues.
    taito_hook_command_executed=true
    (${taito_setv:?}; npm run -s ${npm_command}${params})
    exit_code=$?
  fi

  # taito test posthandling

  if [[ ${running_ci_test} == true ]] && [[ ${exit_code} != 0 ]]; then
    # Notify verify step so that it can revert the changes
    # TODO move this to src/execute-command.sh
    cat "failed" > ./taitoflag_test_failed
  fi
fi

if [[ ${exit_code} != 0 ]]; then
  exit ${exit_code}
elif [[ ${skip_remaining_commands} == false ]]; then
  # Call next command on command chain
  "${taito_cli_path}/util/call-next.sh" "${@}"
fi
