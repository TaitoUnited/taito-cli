#!/bin/bash

: "${taito_cli_path:?}"

content=$(cat "${taito_project_path}/README.md")

# Add also file from project root
if [[ -f "${taito_cli_path}/README.md" ]]; then
  c=$(cat "${taito_cli_path}/README.md")
  content="${content}\n\n\n${c}"
fi

echo -e "${content}" | cat

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
