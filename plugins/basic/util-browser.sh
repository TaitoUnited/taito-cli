#!/bin/bash
: "${taito_cli_path:?}"

"${taito_cli_path}/util/browser.sh" "${1}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
