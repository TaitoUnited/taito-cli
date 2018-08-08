#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ ! ${taito_target:-} ]] || [[ ${taito_target} == "npm" ]]; then
  "${taito_plugin_path}/util/clean.sh"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
