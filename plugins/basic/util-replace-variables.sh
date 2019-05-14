#!/bin/sh
: "${taito_util_path:?}"

"$taito_util_path/replace-variables.sh" "$@"

# Call next command on command chain
"$taito_util_path/call-next.sh" "$@"
