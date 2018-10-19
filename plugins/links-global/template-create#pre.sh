#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ "${link_global_urls:-}${link_urls:-}" == *" conventions="* ]]; then
  echo "Press enter to open the software development conventions page"
  read -r
  "${taito_plugin_path}/util/open.sh" "conventions" "open" "browser.sh" ":"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
