#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project_path:?}"

echo
echo "### npm - oper-clean: Deleting all node_modules directories ###"
echo
echo "NOTE: Remember to run 'taito install' after clean"

find "${taito_project_path}" -name "node_modules" -type d -prune -exec \
  rm -rf '{}' + && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
