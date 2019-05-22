#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"

"${taito_plugin_path}/util/use-context.sh" && \

echo "kubectl: TODO rolling restart instead of kill" && \
if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  . "${taito_plugin_path}/util/determine-pod-container.sh" && \
  (${taito_setv:?}; kubectl delete pod "${pod}")
else
  (${taito_setv:?}; kubectl delete pods -l release="${taito_project}-${taito_target_env}")
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
