#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_name:?}"
: "${template_source_git:?}"

export template="${template_name}"
export template_project_path="${PWD}"

echo
echo "Please wait..."

# Clone template git repo to a temporary template-tmp directory
rm -rf "${template_project_path}/template-tmp"
mkdir "${template_project_path}/template-tmp"
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  export GIT_PAGER="" && \
  git clone -q -b master --single-branch --depth 1 \
    ${template_source_git}/${template}.git ./template-tmp/${template} && \
  taito -c template-upgrade-continue"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
