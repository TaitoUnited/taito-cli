#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

"${taito_plugin_path}/util/use-context.sh" && \

echo "kubectl: TODO rolling restart instead of kill" && \
if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  . "${taito_plugin_path}/util/determine-pod-container.sh" && \
  (${taito_setv:?}; kubectl delete pod "${pod}")
else
  (${taito_setv:?}; kubectl delete pods --all)
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
