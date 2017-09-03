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
echo

mkdir "$HOME/tmp" 2> /dev/null
rm -rf "$HOME/tmp/${template}"
git clone "${template_source_git_url}/${template}.git" \
  "$HOME/tmp/${template}" && \

(
  cd "$HOME/tmp/${template}" || exit 1
  git checkout master
  echo
  "${taito_plugin_path}/util/init.sh" "upgrade"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
