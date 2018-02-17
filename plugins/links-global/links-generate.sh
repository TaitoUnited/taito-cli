#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# TODO add help section for the links-generate command
"${taito_plugin_path}/util/generate.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
