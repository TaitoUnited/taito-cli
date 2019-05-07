#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

target_type=$1

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
