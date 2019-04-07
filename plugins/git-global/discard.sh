#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
git clean -df && \
git checkout -- .
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
