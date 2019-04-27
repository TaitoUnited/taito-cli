#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"

echo "Displaying some zone details..."

(cd terraform && terraform output)

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
