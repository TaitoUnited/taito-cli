#!/bin/bash

function taito::call_next () {
  taito::executing_stop # Just in case

  local chain=(${taito_command_chain[@]})
  local next="${chain[0]}"
  local name
  local plugin_path

  if [[ ${next} != "" ]]; then
    name="${next//\/taito-cli\/plugins\//}"
    name=$(echo "${name}" | cut -f 1 -d '/')
    plugin_path=$(echo "${next/\/hooks/}" | sed -e 's/\/[^\/]*$//g')
    if [[ ${taito_quiet:-} != "true" ]] && ( \
         [[ ${taito_debug} == "true" ]] || [[ ${next} != *"/hooks/"* ]] \
       ); then
      taito_plugin_path="${plugin_path}" taito::print_plugin_title
    fi
    taito_plugin_path="${plugin_path}" taito_command_chain="${chain[@]:1}" \
      "${next}" "${@}"
    exit $?
  else
    exit 0
  fi
}
export -f taito::call_next

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.
function taito::execute_on_host () {
  local commands="${*:1}"
  local sleep_seconds="${2}"

  echo "+ ${commands}" > "${taito_vout}"

  # TODO: clean up this hack (for running docker commands on remote host)
  if [[ ${taito_host:-} ]] && \
     [[ ${taito_command} != "util-test" ]] && \
     [[ ${taito_command} != "test" ]] && \
     [[ ${taito_command} != "auth" ]] && \
     [[ ${taito_env} != "local" ]] && \
     [[ ${commands} == *"docker"* ]]; then
    taito::expose_ssh_opts
    ssh -t ${ssh_opts} "${taito_host}" \
      "bash -c 'cd ${taito_host_dir:?}; if [[ -f taito-config.sh ]]; then . taito-config.sh; fi ; ${commands}'"
  elif [[ ${taito_mode:-} == "ci" ]]; then
    eval "${commands}"
  elif [[ ${taito_run:-} ]]; then
    echo "${commands}" >> ${taito_run}
    sleep "${sleep_seconds:-2}"
  else
    echo
    echo "-----------------------------------------------------------------------"
    echo "NOTE: On Windows you need to execute these commands manually:"
    echo "${commands}"
    echo "-----------------------------------------------------------------------"
    echo
    echo "Press enter after you have executed all the commands"
    read -r
  fi
}
export -f taito::execute_on_host

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.
function taito::execute_on_host_fg () {
  local commands="${*:1}"

  echo "+ ${commands}" > "${taito_vout}" || :

  # TODO: clean up this hack (for running docker commands on remote host)
  if [[ ${taito_host:-} ]] && \
     [[ ${taito_command} != "util-test" ]] && \
     [[ ${taito_command} != "test" ]] && \
     [[ ${taito_command} != "auth" ]] && \
     [[ ${taito_env} != "local" ]] && \
     [[ ${commands} == *"docker"* ]]; then
    taito::expose_ssh_opts
    ssh -t ${ssh_opts} "${taito_host}" \
      "bash -c 'cd ${taito_host_dir:?}; if [[ -f taito-config.sh ]]; then . taito-config.sh; fi ; (${commands})'"
  elif [[ ${taito_mode:-} == "ci" ]]; then
    eval "(${commands})"
  elif [[ ${taito_run_fg:-} ]]; then
    echo "(${commands})" >> ${taito_run_fg}
  else
    echo
    echo "-----------------------------------------------------------------------"
    echo "NOTE: On Windows you need to execute these commands manually:"
    echo "${commands}"
    echo "-----------------------------------------------------------------------"
    echo
  fi
}
export -f taito::execute_on_host_fg

function taito::execute_with_ssh_agent () {
  local commands=$1
  local use_agent=true
  local runner

  if [[ ${SSH_AUTH_SOCK} ]]; then
    # Already running
    use_agent=false
  fi

  runner="bash -c"
  if [[ ${use_agent} == true ]] && which ssh-agent > /dev/null; then
    runner="ssh-agent bash -c"
  fi

  ${runner} "${commands} \"\${@}\"" -- "${@:2}"
}
export -f taito::execute_with_ssh_agent

function taito::add_ssh_key () {
  local force_add=$1

  if [[ ${force_add} != 'true' ]] && (
      [[ ${taito_env:-} == "local" ]] ||
      [[ ${taito_quiet:-} == "true" ]]
     ); then
    return
  fi

  if [[ ! ${taito_host:-} ]]; then
    return
  fi

  echo "Enter SSH key name or leave empty to use the default [id_ed25519]:"
  read -r keyname
  keyname=${keyname:-id_ed25519}

  taito::execute_with_ssh_agent "
    taito::executing_start
    if [[ \"${keyname}\" ]]; then
      ssh-add "${HOME}/.ssh/${keyname:-id_ed25519}";
    fi
  "
}
export -f taito::add_ssh_key

function taito::skip_to_next () {
  taito::call_next "${@}"
  exit $?
}
export -f taito::skip_to_next

function taito::skip_if_not () {
  taito::is_current_target_of_type "${1}" || taito::skip_to_next "${@:2}"
}
export -f taito::skip_if_not
