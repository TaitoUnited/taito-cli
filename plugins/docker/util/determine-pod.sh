#!/bin/bash

: "${taito_project:?}"

if [[ -n "${docker_run:-}" ]] && [[ -z "${1}" ]]; then
  pod="${docker_run}"
else
  pod="${1:?Pod name not given}"
fi

if [[ ${pod} != "${taito_project}-"* ]]; then
  pod="${taito_project}-${pod}"
fi
