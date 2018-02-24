#!/bin/bash

command_path=${1}

next_path=$(echo "${command_path/\hooks/}" | sed -e 's/\/[^\/]*$//g')
export taito_plugin_path="${next_path}"
