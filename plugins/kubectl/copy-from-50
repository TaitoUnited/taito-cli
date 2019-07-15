#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

source="${1:?}"
dest="${2:?}"

"${taito_plugin_path}/util/use-context.sh" && \
. "${taito_plugin_path}/util/determine-pod-container.sh"

(${taito_setv:?}; kubectl cp "${pod}:${source}" "${dest}" -c "${container}")

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
