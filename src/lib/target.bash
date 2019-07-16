#!/bin/bash -e

taito::is_current_target_of_type () {
  local target_type=$1
  local type_variable_name="taito_target_type_${taito_target:-}"
  [[ "${!type_variable_name:-container}" == "$target_type" ]]
}
export -f taito::is_current_target_of_type

taito::print_current_target_type () {
  local type_variable_name="taito_target_type_${taito_target:-}"
  echo "${!type_variable_name:-container}"
}
export -f taito::print_current_target_type

taito::print_targets_of_type () {
  local target_type=$1
  local targets
  local type_variable_name

  if [[ $target_type == "database" ]] && [[ ${taito_databases:-} ]]; then
    # For backwards compatibility
    targets="$taito_databases"
  else
    targets=""
    for target in ${taito_targets:-}
    do
      type_variable_name="taito_target_type_$target"
      if [[ ${!type_variable_name} == "$target_type" ]] || ( \
           [[ ! ${!type_variable_name} ]] && \
           [[ $target_type == "container" ]] \
         ); then
        targets="$targets $target"
      fi
    done
  fi

  echo "$targets"
}
export -f taito::print_targets_of_type
