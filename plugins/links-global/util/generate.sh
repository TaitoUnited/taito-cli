#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project_path:?}"

# Generate markdown links
markdown_links=""
# An environment specific link
envs=("${taito_environments:-}")
for env in ${envs[@]}
do
  output=$( (
    taito_env="${env}"
    . "${taito_project_path}/taito-config.sh"
    links=("${link_urls:-}")
    for link in ${links[@]}
    do
      prefix="$( cut -d '=' -f 1 <<< "$link" )";
      url="$( cut -d '=' -f 2- <<< "$link" )"
      command=${prefix%#*}
      command_env=${command/\[:ENV\]/:${env}}
      command_env=${command_env/:ENV/:${env}}
      if [[ -n ${url} ]]; then
        echo "[${command_env}](${url})"
      fi
    done
  ) )
  markdown_links="${markdown_links}\n${output}  "
done

# Sort markdown links and remove duplicates
markdown_links=$(echo -e "${markdown_links:-}" | sort -u)

# Add links to README.md
{
  sed '/GENERATED LINKS START/q' README.md
  echo -e "${markdown_links}\n"
  sed -n -e '/GENERATED LINKS END/,$p' README.md
} >> README.md.tmp
mv -f README.md.tmp README.md
