#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
echo 'TODO: push only if commit exists in remote repository' && \
git reset HEAD^ --hard && git push origin -f" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
