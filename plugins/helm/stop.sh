#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_env:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \

echo "TODO scale replicas to 0 instead of deleting" && \
echo
echo "Deleting ${taito_project}-${taito_env}. This may also delete data that"
echo "has been stored on a persistent volume. Do you really want to continue?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

(${taito_setv:?}; helm delete --purge "${taito_project}-${taito_env}") && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
