#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

if [[ "${taito_command}" == "open-"* ]]; then
  mode="open"
elif [[ "${taito_command}" == "link-"* ]]; then
  mode="link"
fi
link_name=${taito_command:5:99}

if [[ ! -z ${mode} ]]; then
  if "${taito_plugin_path}/util/open.sh" "${link_name}" "${mode}"; then
    export taito_hook_command_executed="true"
  fi
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
