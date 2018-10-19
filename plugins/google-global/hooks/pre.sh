#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

# Add authuser parameter to all google.com links if google_authuser
# has been defined in personal taito-config.sh
if [[ ${google_authuser:-} ]] && \
   ([[ "${taito_command}" == "open-"* ]] || [[ "${taito_command}" == "link-"* ]])
then
  export link_global_urls
  link_global_urls=$(echo "${link_global_urls}" | sed -re "s|(google\\.com[^ ]*\\?)|\1authuser=${google_authuser}\\&|g")
  export link_urls
  link_urls=$(echo "${link_urls}" | sed -re "s|(google\\.com[^ ]*\\?)|\1authuser=${google_authuser}\\&|g")
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
