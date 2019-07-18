#!/bin/bash
# NOTE: This bash script is run also directly on host.

function taito::is_target_of_type () {
  local target_type=$1
  local target=$2
  local type_variable_name="taito_target_type_${target}"
  [[ "${!type_variable_name:-container}" == "$target_type" ]]
}
export -f taito::is_target_of_type

function taito::is_current_target_of_type () {
  taito::is_target_of_type "${1}" "${taito_target:?}"
}
export -f taito::is_current_target_of_type

function taito::print_current_target_type () {
  local type_variable_name="taito_target_type_${taito_target:-}"
  echo "${!type_variable_name:-container}"
}
export -f taito::print_current_target_type
