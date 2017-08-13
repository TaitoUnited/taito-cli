#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_command:?}"
: "${link_urls:?}"

exit_code=0
found=$(echo "${link_urls}" | grep "${taito_command}[\[\:\=\#]")
if [[ ${found} != "" ]]; then
  links=("${link_urls}")
  for link in ${links[@]}
  do
    prefix="$( cut -d '=' -f 1 <<< "$link" )";
    command_prototype=${prefix%#*}
    command=${command_prototype%:*}
    command=${command%[*}
    if [[ "${command}" == "${taito_command}" ]]; then
      name=${prefix##*#}
      url="$( cut -d '=' -f 2- <<< "$link" )"
      echo
      echo "### link - pre: Opening ${name} ###"
      echo

      if ! "${taito_cli_path}/util/browser.sh" "${url}"; then
        exit 1
      fi
      exit_code=2
      break
    fi
  done
fi

exit ${exit_code}
