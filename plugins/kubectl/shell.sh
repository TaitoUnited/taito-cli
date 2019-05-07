#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

# TODO: do is-target-type check elsewhere also
if "$taito_util_path/is-target-type.sh" container; then
  "${taito_plugin_path}/util/use-context.sh"

  . "${taito_plugin_path}/util/determine-pod-container.sh"
  (${taito_setv:?}; kubectl exec -it "${pod}" -c "${container}" -- "/bin/sh") || \
  (${taito_setv:?}; kubectl exec -it "${pod}" -- "/bin/sh")
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
