#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "kubectl" "${name}" \
  "Rotate secrets"
then
  echo "TODO rotate secrets"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
