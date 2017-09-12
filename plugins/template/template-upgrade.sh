#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_source_git_url:?}"
: "${template_name:?}"
: "${template_source_git_url:?}"

export template="${template_name}"
export template_project_path="${PWD}"

echo
echo "### template - template-upgrade: upgrading to the latest version of \
template ${template} ###"

rm -rf "${template_project_path}/template-tmp"
mkdir "${template_project_path}/template-tmp"

"${taito_cli_path}/util/execute-on-host.sh" "\
  git clone ${template_source_git_url}/${template}.git ./template-tmp/${template} && \
  (cd ./template-tmp/${template} && git checkout master) && \
  echo 'Please wait...'" 15 && \
echo
echo

(
  cd "${template_project_path}/template-tmp/${template}" && \
  "${taito_plugin_path}/util/init.sh" "upgrade"
) && \

rm -rf "${template_project_path}/template-tmp"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
