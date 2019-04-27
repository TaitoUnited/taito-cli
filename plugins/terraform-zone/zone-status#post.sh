#!/bin/bash
: "${taito_util_path:?}"

(cd terraform && terraform output)

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
