#!/bin/bash

current_name=${1}
requested_name=${2}
prompt=${3}

if [[ "${requested_name}" == "" ]] || \
   [[ "${requested_name}" == "-"* ]] || \
   [[ "${requested_name}" == "${current_name}" ]]; then
  if [[ "${prompt}" ]]; then
    echo "${prompt} (Y/n)?"
  else
    echo "Execute ${current_name} (Y/n)?"
  fi
  read -r confirm
  if [[ ${confirm} =~ ^[Yy]*$ ]]; then
    exit 0
  fi
fi

exit 2
