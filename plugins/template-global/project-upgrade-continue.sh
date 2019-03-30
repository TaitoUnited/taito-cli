#!/bin/bash -e

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_name:?}"
: "${template_source_git:?}"

export template="${template_name}"
export template_project_path="${PWD}"

function cleanup {
  # Delete temporary template files and configs
  rm -rf "${template_project_path}/template-tmp"
}
trap cleanup EXIT

# Execute create upgrade of template
(
  set -e
  cd "${template_project_path}/template-tmp/${template}"
  "${taito_plugin_path}/util/init.sh" "upgrade"
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
