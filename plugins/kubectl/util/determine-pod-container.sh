#!/bin/bash
: "${taito_project:?}"
: "${taito_target:?Target not given}"

if [[ ${taito_target} != *"-"* ]]; then
  # Short pod name was given. Determine the full pod name.
  pod=$(kubectl get pods | grep "${taito_project}" | \
    sed -e "s/${taito_project}-//" | \
    grep "${taito_target}" | \
    head -n1 | awk "{print \"${taito_project}-\" \$1;}")
fi

if [[ -z "${container}" ]] || \
   [[ "${container}" == "--" ]] || \
   [[ "${container}" == "-" ]]; then
  # No container name was given. Determine container name.
  container=$(echo "${pod}" | sed -e 's/\([^0-9]*\)*/\1/;s/-[0-9].*$//')
fi
