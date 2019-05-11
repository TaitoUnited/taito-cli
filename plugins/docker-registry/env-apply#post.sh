#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "aws" "${name}" \
  "Configure Docker Hub credentials for CI/CD pipeline"
then
  echo "TODO: instructions"
  echo
  echo "Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
