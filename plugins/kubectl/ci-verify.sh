#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_test_env:-}" == "true" ]]; then
  if [[ -f ./taitoflag_test_env_failed ]]; then
    echo "Tests failed"
    if [[ ${taito_autorevert:-} == "true" ]]; then
      echo "Reverting deployment"
      taito "db-revert:${taito_env}"
      taito "ci-revert:${taito_env}"
    fi
    exit 1
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
