#!/bin/bash
: "${taito_cli_path:?}"

echo "Create a new commit that reverts the latest commit (Y/n)?"
read -r confirm
if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git revert HEAD"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
