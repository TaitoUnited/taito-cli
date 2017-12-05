#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

# Read command names from package.json to check that command exists
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')

if ([[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_test_env:-}" == "true" ]]) &&
   [[ $(echo "${commands}" | grep "^ci-test-e2e:${taito_env}$") != "" ]]; then
  if ! npm run "ci-test-e2e:${taito_env}"; then
    if [[ "${taito_mode:-}" == "ci" ]] && [[ "${taito_env}" != "local" ]]; then
      # In CI mode we notify the verify step so that it can revert the changes
      cat "failed" > ./taitoflag_test_env_failed
    else
      exit 1
    fi
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
