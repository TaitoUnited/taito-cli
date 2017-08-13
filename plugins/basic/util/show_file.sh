#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project_path:?}"

filename="${1}"
command="${2}"

content=""

# Add also file from project root
if [[ -f "${taito_project_path}/${filename}" ]]; then
  c=$(cat "${taito_project_path}/${filename}")
  content="${content}${c}\n\n\n"
fi

c=$(cat "${taito_cli_path}/${filename}")
content="${content}\n\n\n${c}"

plugins=("${taito_enabled_plugins}")
for plugin in ${plugins[@]}
do
  # Check plugin commands only if plugin is enabled for this environment:
  # e.g. docker:local kubectl:-local
  split=("${plugin//:/ }")
  plugin_name="${split[0]}"
  file_path="${taito_cli_path}/plugins/${plugin_name}/${filename}"
  if [[ -f "${file_path}" ]]; then
    c=$(cat "${file_path}")
    content="${content}${c}\n\n\n"
  fi
done

echo -e "${content}" | "${command}"
