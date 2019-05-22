#!/bin/bash
: "${taito_util_path:?}"
: "${taito_host_uname:?}"

. ${taito_plugin_path}/util/opts.sh
ssh "${opts}" "${@}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
