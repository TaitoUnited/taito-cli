#!/bin/bash

function links-global::generate_docs () {
  # Skip link generation for template projects and non-projects
  if [[ ${taito_project:-} == *"-template" ]] || \
     [[ ! -f "${taito_project_path}/taito-config.sh" ]]; then
    return 0
  fi

  # Generate markdown links
  local markdown_links=""

  # Generate links for every environment
  local envs=("${taito_environments:-}")
  if ! [[ ${taito_environments:-} ]]; then
    envs=("dummyenv")
  fi

  for env in ${envs[@]}
  do
    local output=$( (
      export taito_target_env="${env}"
      export taito_env="${env}"
      set -a
      . "${taito_project_path}/taito-config.sh"
      set +a
      while IFS='*' read -ra items; do
        for item in "${items[@]}"; do
          words=(${item})
          link="${words[0]}"
          if [[ ${link} ]]; then
            url="$( cut -d '=' -f 2- <<< "$link" )"
            description="${words[*]:1}"
            description="${description//:ENV/$env}"
            if [[ ! ${description} ]]; then
              prefix="$( cut -d '=' -f 1 <<< "$link" )";
              command=${prefix%#*}
              description=${command/\[:ENV\]/:${env}}
              description=${description/:ENV/:${env}}
            fi
            if [[ ${url} ]] && [[ ${url} != "https:///"* ]]; then
              echo "* [${description}](${url})"
            fi
          fi
        done
      done <<< "${link_urls:-}"
    ) )
    markdown_links="${markdown_links}\n${output}  "
  done

  # Sort markdown links and remove duplicates
  markdown_links=$(echo -e "${markdown_links:-}" | sort -u)

  # Add links to README.md
  {
    sed '/GENERATED LINKS START/q' README.md
    echo -e "${markdown_links}\n"
    sed -n -e '/GENERATED LINKS END/,$p' README.md
  } > README.md.tmp
  truncate --size 0 README.md
  cat README.md.tmp > README.md
  rm -f README.md.tmp
}

function links-global::show_help () {
  echo "PROJECT: LINKS"
  echo

  while IFS='*' read -ra items; do
    for item in "${items[@]}"; do
      words=(${item})
      link="${words[0]}"
      description="${words[*]:1}"
      if [[ ${link} ]]; then
        prefix="$( cut -d '=' -f 1 <<< "$link" )";
        command_prototype=${prefix%#*}
        echo "  open ${command_prototype//-/ }"
        echo "    ${description}"
        echo
      fi
    done
  done <<< "${link_global_urls:-}${link_urls:-}"

  while IFS='*' read -ra items; do
    for item in "${items[@]}"; do
      words=(${item})
      link="${words[0]}"
      description="${words[*]:1}"
      if [[ ${link} ]]; then
        prefix="$( cut -d '=' -f 1 <<< "$link" )";
        command_prototype=${prefix%#*}

        echo "  link ${command_prototype//-/ }"
        echo "    ${description}"
        echo
      fi
    done
  done <<< "${link_global_urls:-}${link_urls:-}"
}

function links-global::open_link () {
  link_name=${1}
  mode=${2:-open}
  open_command=${3:-taito::open_browser_fg}
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
          if [[ ${command// /-} == "${link_name}" ]]; then
            name=${prefix##*#}
            url="$( cut -d '=' -f 2- <<< "$link" )"
            ${echo_command}
            if [[ $DOCKER_HOST ]] && [[ $url == "://localhost" ]]; then
              # Replace localhost with docker host ip address
              host_ip=$(echo "$DOCKER_HOST" | sed "s/.*:\\(.*\\):.*/\\1/")
              url=${url//:\/\/localhost/://$host_ip}
            fi
            if [[ ${mode} == "open" ]]; then
              if [[ ${taito_quiet:-} != "true" ]]; then
                ${echo_command} -e "${taito_command_context_prefix:-}${H1s}links-global${H1e}"
                ${echo_command} Opening link "${url}"
              fi
              "${open_command}" "${url}"
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
}
