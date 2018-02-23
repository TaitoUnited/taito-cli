#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"

export template="${1:?Template not given}"
export template_name="${template}"
export template_project_path="${PWD}"
export template_source_git="${template_default_source_git}"

# TODO read template_source_git from template_name if it has been given as prefix

. "${taito_plugin_path}/util/ask-details.sh"

# Write template migrate settings to a temporary config file
# TODO remove unnecessary settings
echo export template="${template}" >> _template-config.sh && \
echo export template_name="${template}" >> _template-config.sh && \
echo export template_source_git="${template_source_git}" >> _template-config.sh && \
echo export template_dest_git="${template_dest_git:?}" >> _template-config.sh && \
echo export template_project_path="${PWD}" >> _template-config.sh && \
echo export taito_template="${template}" >> _template-config.sh && \
echo export taito_company="${taito_company:?}" >> _template-config.sh && \
echo export taito_family="${taito_family:-}" >> _template-config.sh && \
echo export taito_application="${taito_application:?}" >> _template-config.sh && \
echo export taito_suffix="${taito_suffix:-}" >> _template-config.sh && \
echo export taito_repo_name="${taito_repo_name:?}" >> _template-config.sh && \

# Clone template git repo to a temporary template-tmp directory
rm -rf "${template_project_path}/template-tmp"
mkdir "${template_project_path}/template-tmp"
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  export GIT_PAGER="" && \
  git clone -q -b master --single-branch --depth 1 \
    ${template_source_git}/${template}.git ./template-tmp/${template} && \
  taito -c template migrate continue"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
