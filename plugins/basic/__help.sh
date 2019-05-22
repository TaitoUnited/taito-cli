#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

filter=${1}

echo

# Hack: Show dynamic links of link plugin in the correct place
links=$("${taito_cli_path}/plugins/links-global/util/help.sh" | \
  sed ':a $!{N; ba}; s/\n/\\n/g') && \

if [[ -z "${filter}" ]]; then
  "${taito_plugin_path}/util/show_file.sh" help.txt | \
    sed -e "s|PROJECT: DATABASE OPERATIONS|${links}\nPROJECT: DATABASE OPERATIONS|"
else
  echo QUICK EXAMPLES
  echo
  awk '/^QUICK EXAMPLES/,/^OPTIONS/' "${taito_cli_path}/help.txt" | \
    grep "^    ${filter//-/ }" | sed "s/^    /  /g"
  echo
  echo COMMANDS
  echo
  "${taito_plugin_path}/util/show_file.sh" help.txt | \
    sed -e "s|PROJECT: DATABASE OPERATIONS|${links}\nPROJECT: DATABASE OPERATIONS|" | \
    awk "/^  [a-z]+/ && /${filter//-/ }/,/^$/"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
