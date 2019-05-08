#!/bin/bash -e

. _template-config.sh

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_vc_repository:?}"
: "${template_dest_git:?}"
: "${template_default_git_url:?}"

# Execute create script of template
"${taito_plugin_path}/util/init.sh" "create"

rm -f ./_template-config.sh

taito project-docs

echo
echo "Create a new repository: ${template_dest_git}/${taito_vc_repository}"
echo "The new repository must be completely empty (no README.md, LICENSE,"
echo "or .gitignore). After you have created the empty repository, continue by"
echo "pressing enter."
read -r

doc="README.md#configuration"
if [[ -f "DEVELOPMENT.md" ]]; then
  doc="DEVELOPMENT.md#configuration"
fi
if [[ -f "CONFIGURATION.md" ]]; then
  doc="CONFIGURATION.md"
fi

echo "Please wait..."
"${taito_cli_path}/util/execute-on-host-fg.sh" "
  set -e
  export GIT_PAGER=''
  git init -q
  git add .
  git commit -q -m 'First commit'
  git remote add origin ${template_dest_git}/${taito_vc_repository}.git
  while ! (echo Pushing to git... && git push --force -q -u origin master &> /dev/null)
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
  echo Created directory: ${taito_vc_repository}
  echo Press enter to open configuration instructions.
  read -r
  echo
  if [[ \"${template_dest_git}\" == *\"bitbucket.org:\"* ]]; then
    taito -c util-browser https://${template_default_git_url}/${taito_vc_repository}/src/dev/${doc}
  else
    taito -c util-browser https://${template_default_git_url}/${taito_vc_repository}/blob/dev/${doc}
  fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
