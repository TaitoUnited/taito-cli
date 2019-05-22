#!/bin/bash
: "${taito_util_path:?}"
: "${taito_project_path:?}"

filename="${1:?}"
mode="${2}"

content=""

if [[ "${mode}" == "taito-cli-first" ]]; then
  c=$(cat "${taito_cli_path}/${filename}")
  content="${content}${c}\n\n"
fi

if [[ -f "${taito_project_path}/${filename}" ]]; then
  c=$(cat "${taito_project_path}/${filename}")
  content="${content}${c}\n\n"
fi

if [[ "${mode}" != "taito-cli-first" ]]; then
  c=$(cat "${taito_cli_path}/${filename}")
  content="${content}${c}\n\n"
fi

# Check plugin commands only if plugin is enabled for this environment:
# e.g. docker:local kubectl:-local
extensions=("${taito_cli_path}/plugins ${taito_enabled_extensions}")
for extension in ${extensions[@]}
do
  plugins=("${taito_enabled_plugins}")
  for plugin in ${plugins[@]}
  do
    split=("${plugin//:/ }")
    plugin_name="${split[0]}"
    file_path="${extension}/${plugin_name}/${filename}"
    if [[ -f "${file_path}" ]]; then
      c=$(cat "${file_path}")
      content="${content}${c}\n\n"
    fi
  done
done

echo -e "${content}"
