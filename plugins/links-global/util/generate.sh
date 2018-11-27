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
    export taito_target_env="${env}"
    export taito_env="${env}"
    set -a
    . "${taito_project_path}/taito-config.sh"
    set +a
    while IFS='*' read -ra items; do
      for item in "${items[@]}"; do
        words=(${item})
        link="${words[0]}"
        if [[ ${link} ]]; then
          url="$( cut -d '=' -f 2- <<< "$link" )"
          description="${words[*]:1}"
          description="${description//:ENV/$env}"
          if [[ ! ${description} ]]; then
            prefix="$( cut -d '=' -f 1 <<< "$link" )";
            command=${prefix%#*}
            description=${command/\[:ENV\]/:${env}}
            description=${description/:ENV/:${env}}
          fi
          if [[ -n ${url} ]]; then
            echo "* [${description}](${url})"
          fi
        fi
      done
    done <<< "${link_urls:-}"
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
} > README.md.tmp
truncate --size 0 README.md
cat README.md.tmp > README.md
rm -f README.md.tmp
