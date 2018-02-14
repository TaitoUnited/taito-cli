#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"

export template="${1:?Template not given}"
export template_name="${template}"
export template_source_git="${template_default_source_git}"

# TODO read template_source_git from template_name if it has been given as prefix

"${taito_plugin_path}/util/init.sh" "create" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
