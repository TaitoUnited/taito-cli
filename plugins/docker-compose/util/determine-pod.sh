#!/bin/bash
: "${taito_project:?}"

# TODO was run support???
# if [[ -n "${docker_run:-}" ]] && [[ -z "${taito_target:-}" ]]; then
#   pod="${docker_run}"
# else
#   pod="${taito_target:?Target not given}"
# fi

pod="${1:-$taito_target}"
if [[ ${pod} != "${taito_project}-"* ]]; then
  pod="${taito_project}-${pod}"
fi
