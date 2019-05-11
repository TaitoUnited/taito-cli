#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if [[ "${taito_provider:-}" == "ssh" ]] && \
   [[ "${ci_exec_deploy:-}" == "true" ]] && \
   "${taito_util_path}/confirm-execution.sh" "aws" "${name}" \
   "Configure SSH credentials for CI/CD pipeline"
then
  echo
  echo "TODO: Instructions"
  echo
  echo "Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
