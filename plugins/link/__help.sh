#!/bin/bash

: "${taito_cli_path:?}"
: "${link_urls:?}"

filter=${1}

if [[ -z "${filter}" ]]; then
  echo "LINKS"
  echo "-----"
  echo
fi

links=("${link_urls}")
for link in ${links[@]}
do
  prefix="$( cut -d '=' -f 1 <<< "$link" )";
  command_prototype=${prefix%#*}
  name=${prefix##*#}

  if [[ -z "${filter}" ]] || [[ "${command_prototype}" == "${filter}"* ]]; then
    echo "${command_prototype}"
    echo "  Opens ${name} in browser."
    echo
  fi
done

if [[ -z "${filter}" ]]; then
 echo
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
