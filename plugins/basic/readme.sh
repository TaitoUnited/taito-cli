#!/bin/bash
: "${taito_util_path:?}"

content=$(cat "${taito_project_path}/README.md")

# if [[ -f "${taito_cli_path}/README.md" ]]; then
#   c=$(cat "${taito_cli_path}/README.md")
#   content="${content}\n\n\n${c}"
# fi

echo -e "${content}" | cat

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"