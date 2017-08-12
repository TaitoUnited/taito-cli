#!/bin/bash

: "${taito_cli_path:?}"
: "${link_urls:?}"

echo "LINKS"
echo "-----"
echo

links=("${link_urls}")
for link in ${links[@]}
do
  prefix="$( cut -d ':' -f 1 <<< "$link" )";
  command=${prefix%=*}
  name=${prefix##*=}

  echo "${command}[:ENV]"
  echo "  Opens ${name} in browser."
  echo
done

echo

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
