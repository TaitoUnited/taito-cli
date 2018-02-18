#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_name:?}"
: "${template_source_git:?}"

export template="${template_name}"
export template_project_path="${PWD}"

# Execute create upgrade of template
(
  cd "${template_project_path}/template-tmp/${template}" && \
  "${taito_plugin_path}/util/init.sh" "upgrade"
) && \

# Delete template files
rm -rf "${template_project_path}/template-tmp"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
