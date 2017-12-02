#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_source_git_url:?}"

export template="${1:?Template not given}"
export template_name="${template}"
export template_project_path="${PWD}"

rm -rf "${template_project_path}/template-tmp"
mkdir "${template_project_path}/template-tmp"

"${taito_cli_path}/util/execute-on-host.sh" "\
  git clone ${template_source_git_url}/${template}.git ./template-tmp/${template} && \
  (cd ./template-tmp/${template} && git checkout master) && \
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
  git push origin v0.0.0" && \

rm -rf "${template_project_path}/template-tmp"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
