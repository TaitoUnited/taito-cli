#!/bin/bash


# Runs all integration test suites

suites_success=false

suites=$(ls -1 -d */)
for suite in ${suites[@]}
do
  echo "### SUITE: ${suite}"
  cd "${suite}" || exit 1
  if ! ./suite.sh; then
    echo "SUITE ${suite} - FAILED"
    suites_success=false
  fi
  cd ..
done

# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  echo "ERROR!"
  exit 1
fi

if [[ ${suites_success} == true ]]; then
  echo "### ALL SUITES SUCCEEDED!"
  exit
else
  echo "### SOME OF THE SUITES FAILED!"
  exit 1
fi
