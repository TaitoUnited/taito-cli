#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_command:?}"

if [[ "${taito_command}" == "open-"* ]]; then
  mode="open"
elif [[ "${taito_command}" == "link-"* ]]; then
  mode="link"
fi
link_name=${taito_command:5:99}

if [[ ! -z ${mode} ]]; then
  found=$(echo "${link_global_urls:-}${link_urls:-}" | grep "${link_name}[\[\:\=\#]")
  if [[ ${found} != "" ]]; then
    links=("${link_global_urls:-}" "${link_urls}")
    for link in ${links[@]}
    do
      prefix="$( cut -d '=' -f 1 <<< "$link" )";
      command_prototype=${prefix%#*}
      command=${command_prototype%:*}
      command=${command%[*}
      if [[ "${command// /-}" == "${link_name}" ]]; then
        name=${prefix##*#}
        url="$( cut -d '=' -f 2- <<< "$link" )"
        echo
        if [[ "${mode}" == "open" ]]; then
          echo "### links/pre: Opening ${name}"
          "${taito_cli_path}/util/browser-fg.sh" "${url}"
        else
          echo "### links/pre: Showing link ${name}"
          echo "${url}"
        fi
        break
      fi
    done
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
