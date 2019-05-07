#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

"${taito_plugin_path}/util/use-context.sh"

. "${taito_plugin_path}/util/determine-pod-container.sh"
(${taito_setv:?}; kubectl exec -it "${pod}" -c "${container}" -- "/bin/sh") || \
(${taito_setv:?}; kubectl exec -it "${pod}" -- "/bin/sh")

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
