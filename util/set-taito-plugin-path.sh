#!/bin/bash

command_path=${1}

next_path=$(echo "${command_path}" | sed -e 's/\/[^\/]*$//g')
export taito_plugin_path="${next_path}"
