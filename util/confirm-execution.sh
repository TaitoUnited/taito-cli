#!/bin/bash

current_name=${1}
requested_name=${2}
description=${3}

if [[ "${requested_name}" == "" ]] || \
   [[ "${requested_name}" == "${current_name}" ]]; then
  if [[ "${description}" ]]; then
    echo "${current_name}: ${description}"
  fi
  echo "Execute ${current_name} (Y/n)?"
  read -r confirm
  if [[ ${confirm} =~ ^[Yy]*$ ]]; then
    exit 0
  fi
fi

exit 2
