#!/bin/bash

: "${taito_cli_path:?}"
: "${template_source_git:?}"
: "${template_default_dest_git:?}"
: "${template:?}"

export mode=${1}
export template_customer=${taito_customer:?}
export template_repo_name=${taito_repo_name:?}
export template_repo_name_alt="${taito_repo_name//-/_}"

# Call create/migrate/upgrade script implemented in template
echo
echo "Running ./scripts/taito-template/${mode}.sh of template"
if ! "./scripts/taito-template/${mode}.sh"; then
  exit 1
fi

# Remove template scripts
rm -rf ./scripts/taito-template

if [[ ${mode} != "upgrade" ]]; then
  echo
  echo "--- Manual configuration ---"
  echo
  echo "See configuration instructions at the end of README.md."
  echo "IMPORTANT: Execute each configuration step thoroughly one by one."
  echo
fi
