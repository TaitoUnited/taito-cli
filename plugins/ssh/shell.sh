#!/bin/bash
: "${taito_util_path:?}"
: "${taito_host_uname:?}"

if [[ ! ${taito_target:-} ]]; then
  . ${taito_plugin_path}/util/opts.sh
  (
    ${taito_setv:?}
    ssh -t ${opts} "${taito_ssh_user:?}@${taito_host}" \
      "cd ${taito_host_dir:?}; bash"
  )
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
