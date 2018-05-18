#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_environments:?}"

valids=" dev->test test->staging staging->master "
if [[ " ${taito_environments} " != *" staging "* ]] && \
   [[ " ${taito_environments} " != *" test "* ]]; then
  valids=" dev->master "
elif [[ " ${taito_environments} " != *" staging "* ]]; then
  valids=" dev->test test->master "
elif [[ " ${taito_environments} " != *" test "* ]]; then
  valids=" dev->staging staging->master "
fi

# Determine source branch
if [[ ${1} ]]; then
  source="${1}"
else
  source=$(git symbolic-ref --short HEAD)
fi

# Determine destination branch
dest="${2}"
if [[ ! ${dest} ]]; then
  dest=$(echo "${valids}" | sed "s/.*${source}->\([^[:space:]]*\).*/\1/")
fi

echo "${source}->${dest}"
if [[ "${valids}" != *" ${source}->${dest} "* ]]; then
  echo "Merging from ${source} to ${dest} is not allowed."
  echo "Valid enviroment merges:${valids}"
  exit 1
fi

echo
echo "NOTE: You should always wait for dev environment build to finish"
echo "successfully before merging commits to subsequent environment branches."
echo "Otherwise your build may fail because of a missing container image"
echo "that has not yet been built."
echo
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
