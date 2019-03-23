#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name="${1}"

if "${taito_util_path}/confirm-execution.sh" "generate-secrets" "${name}" \
    "Generate secrets"; then
  echo "Creating secrets"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/create.sh" true
fi && \

# Call next command on command chain. Exported variables:
"${taito_util_path}/call-next.sh" "${@}"
