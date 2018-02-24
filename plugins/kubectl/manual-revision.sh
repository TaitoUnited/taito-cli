#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_env:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

(${taito_setv:?}; helm list | grep "${taito_project}-${taito_env}") && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
