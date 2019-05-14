#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_host_uname:?}"

if [[ ! ${taito_target:-} ]]; then
  . ${taito_plugin_path}/util/opts.sh
  (
    ${taito_setv:?}
    ssh -t ${opts} "${taito_ssh_user:?}@${taito_host}" \
      "cd /projects/${taito_namespace}; bash"
  )
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
