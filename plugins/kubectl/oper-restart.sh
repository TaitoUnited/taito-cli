#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

"${taito_plugin_path}/util/use-context.sh" && \

if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  echo "TODO implement: Restart only the container given as argument"
  exit 1
else
  (${taito_setv:?}; kubectl delete pods --all) && \
  echo "kubectl: TODO rolling restart instead of kill"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
