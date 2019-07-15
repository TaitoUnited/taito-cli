#!/bin/bash -e

title="${1}"
question="${2}"
items=("${3}")
item_id="${4}"
allow_skip="${5}"

skip=false
while [[ ${skip} == false ]] && [[ ! "${item_id}" ]] && [[ -n "${items[*]}" ]]; do
  echo "${title}"
  for item in ${items[@]}; do echo "- ${item%:*}"; done
  echo
  if [[ "${allow_skip}" == "true" ]]; then
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
  if [[ "${selected_name}" == "-" ]] && [[ "${allow_skip}" == "true" ]]; then
    skip=true
  fi
done
