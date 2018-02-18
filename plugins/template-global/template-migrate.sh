#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"

export template="${1:?Template not given}"
export template_name="${template}"
export template_project_path="${PWD}"
export template_source_git="${template_default_source_git}"

# TODO read template_source_git from template_name if it has been given as prefix

rm -rf "${template_project_path}/template-tmp"
mkdir "${template_project_path}/template-tmp"

"${taito_cli_path}/util/execute-on-host.sh" "\
  export GIT_PAGER="" && \
  git clone -q -b master --single-branch --depth 1 \
    ${template_source_git}/${template}.git ./template-tmp/${template} && \
  echo 'Please wait...'" && \
  sleep 15 && \
echo && \
echo && \

(
  cd "${template_project_path}/template-tmp/${template}" && \
  "${taito_plugin_path}/util/init.sh" "migrate"
) && \

# Create initial tag
"${taito_cli_path}/util/execute-on-host.sh" "\
  git tag v0.0.0 && \
  git push -q origin v0.0.0" && \

rm -rf "${template_project_path}/template-tmp"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
