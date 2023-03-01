#!/bin/bash
# NOTE: This bash script is run also directly on host.

function taito::is_target_of_type () {
  local target_types=$1
  local target=$2

  if [[ ! "${target}" ]]; then
    return false
  fi

  local found=false
  for type in ${target_types[@]}; do
    local type_variable_name="taito_${type}s"
    if [[ " ${!type_variable_name} " == *" ${target} "* ]]; then
      found=true
    fi
  done

  [[ ${found} == "true" ]]
}
export -f taito::is_target_of_type

function taito::is_current_target_of_type () {
  taito::is_target_of_type "${1}" "${taito_target:-}"
}
export -f taito::is_current_target_of_type
