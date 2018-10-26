#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_vc_repository:?}"
: "${template_source_git:?}"
: "${template_default_dest_git:?}"
: "${template:?}"

export mode=${1}
export taito_vc_repository_alt="${taito_vc_repository//-/_}"

# Call create/migrate/upgrade script implemented in template
echo
echo "Running ./scripts/taito-template/${mode}.sh of template"
if ! "./scripts/taito-template/${mode}.sh"; then
  exit 1
fi

# Remove template scripts
rm -rf ./scripts/taito-template
