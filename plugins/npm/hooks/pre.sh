#!/bin/bash
: "${taito_util_path:?}"
: "${taito_skip_override:?}"
: "${taito_command:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${taito_dout:?}"

export taito_hook_command_executed=${taito_hook_command_executed}

exit_code=0
skip_remaining_commands=false

# EXAMPLE: taito test:server:dev --option1 --option2 suite user
# - taito_command = "test"
# - target = ":server"
# - taito_env = "dev"
# - options = ":option1:option2"
# - params = " -- suite user"

target=""
if [[ "${taito_target:-}" ]]; then
  target=":${taito_target}"
fi

options=""
params=""
for arg
do
  if [[ "$arg" == "--"* ]] && [[ -z "${params}" ]]; then
    options="${options}:${1#--}"
  elif [[ -z "${params}" ]]; then
    params=" -- ${arg}"
  else
    params="${params} ${arg}"
  fi
done

echo "command: ${taito_command}" > ${taito_dout}
echo "env: ${taito_env}" > ${taito_dout}
echo "target suffix: ${target}" > ${taito_dout}
echo "options suffix: ${options}" > ${taito_dout}
echo "params suffix: ${params}" > ${taito_dout}

if [[ -f "./package.json" ]] || [[ "${taito_testing:-}" ]]; then
  # Read command names from package.json
  commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')

  # TODO refactor: this is awful!
  if [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${target}:${taito_env}${options}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-${taito_command}${target}:${taito_env}${options}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-${taito_command}${target}${options}$") != "" ]]; then
    # Use overriding command from package.json without enviroment target
    npm_command="taito-${taito_command}${target}${options}"
    skip_remaining_commands=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-host-${taito_command}${target}:${taito_env}${options}$") != "" ]]; then
    # Use overriding command from package.json
    npm_command="taito-host-${taito_command}${target}:${taito_env}${options}"
    skip_remaining_commands=true
    run_on_host=true
  elif [[ ${taito_skip_override} == false ]] && \
     [[ $(echo "${commands}" | grep "^taito-host-${taito_command}${target}${options}$") != "" ]]; then
    # Use overriding command from package.json without enviroment target
    npm_command="taito-host-${taito_command}${target}${options}"
    skip_remaining_commands=true
    run_on_host=true
  elif [[ $(echo "${commands}" | grep "^${taito_command}${target}:${taito_env}${options}$") != "" ]]; then
    # Use normal command from package.json
    npm_command="${taito_command}${target}:${taito_env}${options}"
  elif [[ $(echo "${commands}" | grep "^${taito_command}${target}${options}$") != "" ]]; then
    # Use normal command from package.json without enviroment target
    npm_command="${taito_command}${target}${options}"
  fi

  # taito test prehandling

  # TODO: 'npm_command == test' and 'npm_command == taito-test' can be removed?
  running_ci_test="false"
  if [[ "${taito_mode:-}" == "ci" ]] && \
     ( \
       [[ "${taito_command}" == "test" ]] || \
       [[ "${npm_command}" == "test" ]] || \
       [[ "${npm_command%%:*}" == "test" ]] || \
       [[ "${npm_command%%:*}" == "taito-test" ]] \
     ); then
     running_ci_test="true"
  fi

  # TODO: should be in taito-cli core only?
  if [[ "${running_ci_test}" == "true" ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
    echo "Skipping test because ci_exec_test != true"
    npm_command=""
    running_ci_test=false
    taito_hook_command_executed=true
  fi

  # NOTE: ci-release is deprecated
  if [[ "${taito_command}" == "build-release"* ]] || \
     [[ "${taito_command}" == "artifact-release"* ]] || \
     [[ "${taito_command}" == "ci-release"* ]]; then
    # TODO: remove this artifact-release skip hack
    npm_command=""
  fi

  # run npm command

  if [[ "${taito_debug:-}" == "true" ]]; then
    echo "taito_mode: ${taito_mode:-}"
    echo "taito_command: ${taito_command}"
    echo "npm_command: ${taito_command}"
  fi

  if [[ "${npm_command}" != "" ]]; then
    # Run it
    echo
    echo -e "${H1s}npm${H1e}"
    echo "Running script '${npm_command}${params}'"
    # NOTE: Intentionally removed parameter support: -- "${@}"
    # NOTE: All libs are installed using 'npm install' run on directly on host.
    #       Perhaps some npm scripts should also be run on host to avoid
    #       compatibilty issues.
    taito_hook_command_executed=true
    if [[ "${run_on_host}" == "true" ]]; then
      "${taito_util_path}/execute-on-host-fg.sh" "
        export taito_command_context='npm ${npm_command}'
        npm run -s ${npm_command}${params}
      "
      exit_code=0
    else
      (
        export taito_command_context="npm ${npm_command}"
        ${taito_setv:?}
        npm run -s ${npm_command}${params}
      )
      exit_code=$?
    fi
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
  "${taito_util_path}/call-next.sh" "${@}"
fi
