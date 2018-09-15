#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_environments:?}"

echo asdf
valids=""
prev_env=""
for env in ${taito_environments}
do
  env="${env/prod/master}"
  if [[ ${env} != "feat"* ]]; then
    if [[ ${prev_env} ]]; then
      valids="${valids} ${prev_env}->${env} "
    fi
    prev_env="${env}"
  fi
done

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
echo "Merging ${source} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  exit 130
fi

# TODO execute remote merge using hub cli?
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
git fetch origin ${source}:${dest} && \
git push --no-verify origin ${dest}; \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
