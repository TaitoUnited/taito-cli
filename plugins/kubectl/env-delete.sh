#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_namespace:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

echo "Deleting secrets from Kubernetes" && \
"${taito_plugin_path}/util/delete-secrets.sh" && \

echo "Delete and purge helm release ${taito_project}-${taito_env} (Y/n)?" && \
read -r confirm && \
if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  (${taito_setv:?}; helm delete --purge "${taito_project}-${taito_env}")
fi && \

echo "Delete namespace ${taito_namespace} (Y/n)?" && \
echo "WARNING: Do not delete the namespace if it contains also some other apps" && \
read -r confirm && \
if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  (${taito_setv:?}; kubectl delete namespace "${taito_namespace}")
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
