#!/bin/bash

# TODO obsolete?

: "${tests:?}"

# Runs all tests and verifies them

success=true

IFS=';' read -ra commands <<< "${tests}"
for command in "${commands[@]}"
do
  echo "### TEST: ${command}"
  # shellcheck disable=SC2086
  if ! eval ${command}; then
    echo "${command} - FAILED"
    success=false
  fi
done

if [[ ${success} == true ]]; then
  echo "### TEST SUITE SUCCEEDED!"
  exit
else
  echo "### TEST SUITE FAILED!"
  exit 1
fi
