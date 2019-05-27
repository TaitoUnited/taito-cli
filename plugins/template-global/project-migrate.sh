#!/bin/bash -e

: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"

export template="${1:?Template not given}"
export template_name="${template}"
export template_project_path="${PWD}"
export template_source_git="${template_default_source_git}"
export template_dest_git="${template_default_dest_git:?}"

# TODO read template_source_git from template_name if it has been given as prefix

echo
if [[ "${taito_organization_param:-}" ]]; then
  echo "Migrating project with '${taito_organization_param:-}' settings"
else
  echo "Migrating project with personal default settings"
fi
. "${taito_plugin_path}/util/ask-details.sh"

# Validate current git repository name
current_vc_url=$(git config --get remote.origin.url)
dest_vc_url="${template_dest_git:?}/${taito_vc_repository:?}.git"
if [[ $current_vc_url != "$dest_vc_url" ]]; then
  echo "ERROR: Git url '$current_vc_url' does not match with '$dest_vc_url'!"
  echo "Rename the git repository first and only then run the migration."
  exit 1
fi

# Clone template git repo to a temporary template-tmp directory
# and then continue the migration there.
echo
echo "Please wait."
rm -rf "./template-tmp"
mkdir "./template-tmp"
"${taito_util_path}/execute-on-host-fg.sh" "
  set -e
  export GIT_PAGER=''
  git clone -q -b master --single-branch --depth 1 \
    ${template_source_git}/${template}.git ./template-tmp/${template}
  rm -rf ./template-tmp/${template}/.git
  yes | cp ./template-tmp/${template}/taito-config.sh .
  echo 'export template=${template}' >> _template-config.sh
  echo 'export template_name=${template}' >> _template-config.sh
  echo 'export template_source_git=${template_source_git}' >> _template-config.sh
  echo 'export template_dest_git=${template_dest_git}' >> _template-config.sh
  echo 'export template_project_path=${PWD}' >> _template-config.sh
  echo 'export taito_template=${template}' >> _template-config.sh
  echo 'export taito_company=${taito_company:?}' >> _template-config.sh
  echo 'export taito_family=${taito_family:-}' >> _template-config.sh
  echo 'export taito_application=${taito_application:?}' >> _template-config.sh
  echo 'export taito_suffix=${taito_suffix:-}' >> _template-config.sh
  echo 'export taito_vc_repository=${taito_vc_repository}' >> _template-config.sh
  taito ${taito_options:-} project migrate continue
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
