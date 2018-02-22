#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

args=(${@:0})

# Convert space syntax to internal hyphen syntax
if [[ "${args[0]}" != *"-"* ]]; then
  space_cmd=()
  space_args=()
  mark_found="false"
  for arg in "${args[@]}"
  do
    if [[ "${arg}" == "-"* ]] || [[ ${mark_found} == "true" ]]; then
      mark_found="true"
      space_args+=(${arg})
    elif [[ "${arg}" == *":"* ]] && [[ ${mark_found} == "false" ]]; then
      mark_found="true"
      space_cmd+=(${arg})
    elif [[ ${mark_found} == "false" ]]; then
      space_cmd+=(${arg})
    fi
  done
  space_cmd="${space_cmd[@]}"
  args=("${space_cmd// /-}" ${space_args[@]})
fi

echo "${args[@]}"
