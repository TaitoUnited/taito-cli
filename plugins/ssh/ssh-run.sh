#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_host_uname:?}"

. ${taito_plugin_path}/util/opts.sh
ssh "${opts}" "${@}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
