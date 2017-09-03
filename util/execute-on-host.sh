#!/bin/bash

# Executes the given shell commands on host

commands="${1:?}"
sleep_seconds="${2}"

echo
echo "### Taito-cli running on host ###"
echo
echo "${taito_run}${commands}${taito_run}"
echo

sleep ${sleep_seconds:-2}
