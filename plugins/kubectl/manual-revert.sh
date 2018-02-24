#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_env:?}"

revision="${1:-0}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

(${taito_setv:?}; helm rollback "${taito_project}-${taito_env}" "${revision}") && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
