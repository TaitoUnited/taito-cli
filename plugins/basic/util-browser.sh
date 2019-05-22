#!/bin/bash
: "${taito_util_path:?}"

"${taito_util_path}/browser.sh" "${1}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
