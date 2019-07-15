#!/bin/bash
: "${taito_util_path:?}"

current_name=${1}
requested_name=${2}
prompt=${3}

if [[ "${requested_name}" == "" ]] || \
   [[ "${requested_name}" == "-"* ]] || \
   [[ "${requested_name}" == "${current_name}" ]]; then
  if [[ "${prompt}" ]]; then
    text="${prompt}?"
  else
    text="Execute ${current_name}?"
  fi
  if "$taito_util_path/confirm.sh" "$text"; then exit 0; fi
fi

exit 2
