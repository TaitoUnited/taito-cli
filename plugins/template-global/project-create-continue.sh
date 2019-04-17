#!/bin/bash

. _template-config.sh

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_vc_repository:?}"
: "${template_dest_git:?}"
# TODO: separate setting for git organization
: "${template_default_organization:?}"

# Execute create script of template
"${taito_plugin_path}/util/init.sh" "create" && \

rm -f ./_template-config.sh && \

taito project-docs && \

echo && \
echo Create a new repository: ${template_dest_git}/${taito_vc_repository} && \
echo Leave the README.md uninitialized. After you have created the empty repository, && \
echo continue by pressing enter. && \
read -r && \

doc="README.md#configuration"
if [[ -f "DEVELOPMENT.md" ]]; then
  doc="DEVELOPMENT.md#configuration"
fi
if [[ -f "CONFIGURATION.md" ]]; then
  doc="CONFIGURATION.md"
fi

echo "Please wait..." && \
"${taito_cli_path}/util/execute-on-host-fg.sh" "
  set -e
  export GIT_PAGER=''
  git init -q
  git add .
  git commit -q -m 'First commit'
  git remote add origin ${template_dest_git}/${taito_vc_repository}.git
  while ! echo Pushing to git... && git push -q -u origin master &> /dev/null
  do
    echo Failed pushing to ${template_dest_git}/${taito_vc_repository}.
    echo Make sure the repository exists and press enter.
    read -r
  done
  git tag v0.0.0
  git push -q origin v0.0.0
  git checkout -q -b dev
  git push -q -u origin dev &> /dev/null
  echo
  echo DONE! Now configure your project!
  echo Press enter to open configuration instructions.
  read -r
  echo
  taito -c util-browser https://github.com/${template_default_organization}/${taito_vc_repository}/blob/dev/${doc}
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
