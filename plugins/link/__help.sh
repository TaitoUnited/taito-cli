#!/bin/bash

: "${taito_cli_path:?}"
: "${link_urls:?}"

filter=${1}

if [[ -z "${filter}" ]]; then
  echo "LINKS"
  echo "-----"
  echo

  links=("${link_urls}")
  for link in ${links[@]}
  do
    prefix="$( cut -d '=' -f 1 <<< "$link" )";
    command_prototype=${prefix%#*}
    name=${prefix##*#}

    echo "${command_prototype}"
    echo "  Opens ${name} in browser."
    echo
  done

  echo
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
