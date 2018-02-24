#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "

if [[ "${switches}" == *"--clean"* ]]; then
  "${taito_plugin_path}/util/clean.sh"
fi && \
(${taito_setv:?}; npm install) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
