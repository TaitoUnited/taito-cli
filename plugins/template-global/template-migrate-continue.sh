#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"

. _template-config.sh

# Execute migrate script of template
(
  cd "${template_project_path:?}/template-tmp/${template:?}" && \
  "${taito_plugin_path}/util/init.sh" "migrate"
) && \

# Delete template files
rm -rf "${template_project_path}/template-tmp"

rm -f ./_template-config.sh && \

# Create initial tag
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git tag v0.0.0 && \
  git push -q origin v0.0.0" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
