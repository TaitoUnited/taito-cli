#!/bin/bash

function taito::expose_ssh_opts () {
  ssh_opts=""
  if [[ -f "${HOME}/.ssh/config.taito" ]]; then
    ssh_opts="-F${HOME}/.ssh/config.taito"
  elif [[ ${taito_host_uname} == "Darwin" ]]; then
    echo
    echo "WARNING! ~/.ssh/config.taito file does not exist! SSH execution will"
    echo "fail if your ~/.ssh/config file contains any macOS specific properties"
    echo "(e.g. UseKeyChain)."
  fi

  read -t 1 -n 10000 || :
  if [[ ! ${taito_ssh_user} ]]; then
    echo
    echo "SSH username has not been set. Set taito_ssh_user environment variable"
    echo "in ./taito-user-config.sh or ~/.taito/taito-config.sh to avoid prompt."
    echo "SSH username:"
    read -r taito_ssh_user
    export taito_ssh_user=${taito_ssh_user}
  fi
}
export -f taito::expose_ssh_opts

function taito::show_file () {
  local filename="${1:?}"
  local mode="${2}"

  local content
  local c
  if [[ ${mode} == "taito-cli-first" ]]; then
    c=$(cat "${taito_cli_path}/${filename}")
    content="${content}${c}\n\n"
  fi

  if [[ -f "${taito_project_path}/${filename}" ]]; then
    c=$(cat "${taito_project_path}/${filename}")
    content="${content}${c}\n\n"
  fi

  if [[ ${mode} != "taito-cli-first" ]]; then
    c=$(cat "${taito_cli_path}/${filename}")
    content="${content}${c}\n\n"
  fi

  # Check plugin commands only if plugin is enabled for this environment:
  # e.g. docker:local kubectl:-local
  local extensions=("${taito_cli_path}/plugins ${taito_enabled_extensions}")
  for extension in ${extensions[@]}
  do
    local plugins=("${taito_enabled_plugins}")
    for plugin in ${plugins[@]}
    do
      local split=("${plugin//:/ }")
      local plugin_name="${split[0]}"
      local file_path="${extension}/${plugin_name}/${filename}"
      if [[ -f "${file_path}" ]]; then
        c=$(cat "${file_path}")
        content="${content}${c}\n\n"
      fi
    done
  done

  echo -e "${content}"
}
export -f taito::show_file

function taito::select_item () {
  local title="${1}"
  local question="${2}"
  local items=("${3}")
  local item_id="${4}"
  local allow_skip="${5}"

  local name
  local id
  local item_id
  local skip=false
  while [[ ${skip} == false ]] && [[ ! "${item_id}" ]] && [[ ${items[*]} ]]; do
    echo "${title}"
    for item in ${items[@]}; do echo "- ${item%:*}"; done
    echo
    if [[ ${allow_skip} == "true" ]]; then
      echo "You can enter hyphen(-) to skip."
    fi
    echo "${question}"
    read -r selected_name
    for item in ${items[@]}; do
      name=${item%:*}
      id=${item##*:}
      if [[ ${name} == ${selected_name} ]]; then
        item_id="${id}"
      fi
    done
    if [[ ${selected_name} == "-" ]] && [[ ${allow_skip} == "true" ]]; then
      skip=true
    fi
  done
}
export -f taito::select_item

function taito::show_db_proxy_details () {
  taito::expose_db_user_credentials

  echo "- host: 127.0.0.1"
  echo "- port: ${db_database_external_port:-$database_port}"
  echo "- database: ${database_name:-}"

  if [[ ${taito_mode:-} != "ci" ]]; then
    echo "- username and password:"
    echo "  * Your personal database username and password (if you have one)"
    if [[ ${database_mgr_username:-} ]]; then
      echo "  * ${database_mgr_username} / ${database_build_password:-}"
    fi
    if [[ ${database_app_username:-} ]]; then
      echo "  * ${database_app_username} / ${database_app_password:-}"
    fi
  fi
}
export -f taito::show_db_proxy_details

function taito::substitute_variable_values_in_file () {
  # TODO: REMOVE THESE. ALWAYS USE PIPING!
  local source_file=$1
  local dest_file=$2

  # Substitute environment variables
  if [[ $dest_file ]]; then
    (
      taito::executing_start
      perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg' \
        $source_file > $dest_file
    )
  else
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : ""/eg'
  fi
}
export -f taito::substitute_variable_values_in_file
