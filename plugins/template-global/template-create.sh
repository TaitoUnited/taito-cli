#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

export template="${1:?Template not given}"
export template_source_git="${template_default_source_git:?}"
export template_dest_git="${template_default_dest_git:?}"

# TODO read template_source_git from template_name if it has been given as prefix

. "${taito_plugin_path}/util/ask-details.sh"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  export GIT_PAGER="" && \
  git clone -q -b master --single-branch --depth 1 ${template_source_git}/${template}.git ${taito_repo_name:?} && \
  cd ${taito_repo_name} && \
  # Write template migrate settings to a temporary config file
  # TODO remove unnecessary settings
  echo 'export template=${template}' >> _template-config.sh && \
  echo 'export template_name=${template}' >> _template-config.sh && \
  echo 'export template_source_git=${template_source_git}' >> _template-config.sh && \
  echo 'export template_dest_git=${template_dest_git}' >> _template-config.sh && \
  echo 'export template_project_path=${PWD}' >> _template-config.sh && \
  echo 'export taito_template=${template}' >> _template-config.sh && \
  echo 'export taito_customer=${taito_customer:?}' >> _template-config.sh && \
  echo 'export taito_repo_name=${taito_repo_name}' >> _template-config.sh && \
  rm -rf .git && \
  echo && \
  echo NOTE: Create a new GitHub repository: ${template_dest_git}/${taito_repo_name} && \
  echo Leave the README.md uninitialized. && \
  echo Then continue by running: && \
  echo '\$ cd ${taito_repo_name}; taito template create continue'"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
