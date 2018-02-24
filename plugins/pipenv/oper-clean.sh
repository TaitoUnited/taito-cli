#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project_path:?}"

echo "NOTE: Remember to run 'taito install' after clean"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "pipenv uninstall --all"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
