#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name="${1}"

if "${taito_util_path}/confirm-execution.sh" "generate-secrets" "${name}" \
    "Clean up secrets"; then
  "${taito_plugin_path:?}/util/confirm-file-delete.sh"
fi

# Call next command on command chain. Exported variables:
"${taito_util_path}/call-next.sh" "${@}"
