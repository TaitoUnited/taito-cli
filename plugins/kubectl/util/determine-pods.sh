#!/bin/bash
: "${taito_project:?}"
: "${taito_target:?Target not given}"
: "${taito_target_env:?}"

prefix="${taito_project}"
if [[ "${taito_version:-}" -ge "1" ]]; then
  prefix="${taito_project}-${taito_target_env}"
fi

pods=$(
  kubectl get pods | \
  grep "${prefix}" | \
  sed -e "s/${prefix}-//" | \
  grep "${taito_target}" | \
  awk "{print \"${prefix}-\" \$1;}" | \
  tr '\n' ' '
)
