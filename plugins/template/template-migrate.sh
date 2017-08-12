#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_source_git_url:?}"

export template="${1}"
export template_name="${template}"
export template_project_path="${PWD}"

echo
echo "### template - template-migrate: Migrating existing project to template ${template} ###"
echo

mkdir "$HOME/tmp" 2> /dev/null
rm -rf "$HOME/tmp/${template}"
if ! git clone "${template_source_git_url}/${template}.git" "$HOME/tmp/${template}"; then
  exit 1
fi

if ! (
  cd "$HOME/tmp/${template}" || exit 1
  git checkout master
  echo
  if ! "${taito_plugin_path}/util/init.sh" "migrate"; then
    exit 1
  fi
); then
  exit 1
fi

# Create initial tag
git tag v0.0.0
git push --tags

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
