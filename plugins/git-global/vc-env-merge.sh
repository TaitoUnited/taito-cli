#!/bin/bash
: "${taito_cli_path:?}"

dest="${taito_branch:?Destination branch name not given}"
if [[ ${1} ]]; then
  source="${1}"
else
  source=$(git symbolic-ref --short HEAD)
fi

if [[ -n ${taito_environments:-} ]]; then
  valids=" dev->test test->staging staging->master "
  if [[ " ${taito_environments} " != *" staging "* ]] && \
     [[ " ${taito_environments} " != *" test "* ]]; then
    valids=" dev->master "
  elif [[ " ${taito_environments} " != *" staging "* ]]; then
    valids=" dev->test test->master "
  elif [[ " ${taito_environments} " != *" test "* ]]; then
    valids=" dev->staging staging->master "
  fi
  echo "${source}->${dest}"
  if [[ "${valids}" != *" ${source}->${dest} "* ]]; then
    echo "Merging from ${source} to ${dest} is not allowed."
    echo "Valid enviroment merges:${valids}"
    exit 1
  fi
fi

echo "Merging ${source} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# TODO execute remote merge using hub cli?
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
git fetch origin ${source}:${dest} && \
git push --no-verify origin ${dest}; \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
