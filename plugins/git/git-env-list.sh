#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### git - git-env-list: Listing environment branches ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git branch -a | grep remotes | sed s/^[^\\/]*\\\\/[^\\/]*\\\\/// | \
  grep -v / " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
