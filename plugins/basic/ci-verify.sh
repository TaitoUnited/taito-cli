#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_test:-}" == "true" ]]; then
  if [[ -f ./taitoflag_test_failed ]]; then
    echo "Tests failed"
    if [[ ${ci_exec_revert:-} == "true" ]]; then
      echo "Reverting deployment"
      (
        ${taito_setv:?}
        taito "db-revert:${taito_env}"
        taito "manual-revert:${taito_env}"
      )
    fi
    exit 1
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"