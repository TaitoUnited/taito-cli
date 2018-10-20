#!/bin/bash -e

title="${1}"
question="${2}"
items=("${3}")
item_id="${4}"

while [[ ! "${item_id}" ]] && [[ -n "${items[*]}" ]]; do
  echo "${title}"
  for item in ${items[@]}; do echo "- ${item%:*}"; done
  echo
  echo "${question}"
  read -r selected_name
  for item in ${items[@]}; do
    name=${item%:*}
    id=${item##*:}
    if [[ ${name} == ${selected_name} ]]; then
      item_id="${id}"
    fi
  done
done
