#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "

if [[ "${switches}" == *"--clean"* ]]; then
  "${taito_plugin_path}/util/clean.sh"
  # echo "Cleaning npm cache" && \
  # (${taito_setv:?}; su taito -s /bin/sh -c 'npm cache clean')
fi && \
echo "Running 'npm install'..." && \
(${taito_setv:?}; su taito -s /bin/sh -c 'npm install') && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
