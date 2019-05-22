#!/bin/bash
: "${taito_setv:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/../helm/util/helm.sh" list

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
