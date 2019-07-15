#!/bin/bash
: "${taito_util_path:?}"
: "${taito_command:?}"

link_name=${1}
mode=${2:-open}
open_command=${3:-browser-fg.sh}
echo_command=${4:-echo}

found=$(echo "${link_global_urls:-}${link_urls:-}" | grep "${link_name}[\[\:\=\#]")
if [[ ${found} != "" ]]; then
  while IFS='*' read -ra items; do
    for item in "${items[@]}"; do
      words=(${item})
      link="${words[0]}"
      description="${words[*]:1}"
      if [[ ${link} ]]; then
        prefix="$( cut -d '=' -f 1 <<< "$link" )";
        command_prototype=${prefix%#*}
        command=${command_prototype%:*}
        command=${command%[*}
        if [[ "${command// /-}" == "${link_name}" ]]; then
          name=${prefix##*#}
          url="$( cut -d '=' -f 2- <<< "$link" )"
          ${echo_command}
          if [[ $DOCKER_HOST ]] && [[ $url == "://localhost" ]]; then
            # Replace localhost with docker host ip address
            host_ip=$(echo "$DOCKER_HOST" | sed "s/.*:\\(.*\\):.*/\\1/")
            url=${url//:\/\/localhost/://$host_ip}
          fi
          if [[ "${mode}" == "open" ]]; then
            if [[ ${taito_quiet:-} != "true" ]]; then
              ${echo_command} -e "${taito_command_context_prefix:-}${H1s}links-global${H1e}"
              ${echo_command} Opening link "${url}"
            fi
            "${taito_util_path}/${open_command}" "${url}"
          else
            [[ ${taito_quiet:-} != "true" ]] && \
              ${echo_command} -e "${taito_command_context_prefix:-}${H1s}links-global${H1e}"
              ${echo_command} "Showing link ${name}"
            ${echo_command} "${url}"
          fi
          exit 0
        fi
      fi
    done
  done <<< "${link_global_urls:-} ${link_urls:-}"
fi

# Not found
exit 1
