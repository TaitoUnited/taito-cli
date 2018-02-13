#!/bin/bash

: "${taito_cli_path:?}"

echo "PROJECT: LINKS"
echo

links=("${link_urls:-}")
for link in ${links[@]}
do
  prefix="$( cut -d '=' -f 1 <<< "$link" )";
  command_prototype=${prefix%#*}
  name=${prefix##*#}

  echo "  open ${command_prototype//-/ }"
  echo "    Opens ${name} link in browser."
  echo
done

for link in ${links[@]}
do
  prefix="$( cut -d '=' -f 1 <<< "$link" )";
  command_prototype=${prefix%#*}
  name=${prefix##*#}

  echo "  link ${command_prototype//-/ }"
  echo "    Shows ${name} link."
  echo
done

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
