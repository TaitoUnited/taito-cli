#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ! ${1} ]] || [[ ${1} == "npm" ]]; then
  "${taito_plugin_path}/util/clean.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
