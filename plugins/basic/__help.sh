#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

filter=${1}

if [[ -z "${filter}" ]]; then
  echo
  echo "### basic - --help: Showing help files ###"
fi
echo

# Hack: Show dynamic links of link plugin in the correct place
links=$("${taito_cli_path}/plugins/link/util/help.sh" | \
  sed ':a $!{N; ba}; s/\n/\\n/g') && \

if [[ -z "${filter}" ]]; then
  "${taito_plugin_path}/util/show_file.sh" help.txt | \
    sed -e "s|PROJECT: DATABASE OPERATIONS|${links}\nPROJECT: DATABASE OPERATIONS|"
else
  "${taito_plugin_path}/util/show_file.sh" help.txt | \
    sed -e "s|PROJECT: DATABASE OPERATIONS|${links}\nPROJECT: DATABASE OPERATIONS|" | \
    awk "/^  [a-z]+/ && /${filter//-/ }/,/^$/"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
