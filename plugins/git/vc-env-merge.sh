#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_environments:?}"

# Parse arguments
source=""
dest=""
git_push_options=""
while [[ $# -gt 0 ]]
do
  if [[ ${1} == "--force" ]]; then
    git_push_options="--force"
  elif [[ ${1} == "--" ]]; then
    echo "ERROR: Invalid option ${1}"
    exit 1
  elif [[ ! ${source} ]]; then
    source=${1/prod/master}
  elif [[ ! ${dest} ]]; then
    dest=${1/prod/master}
  else
    echo "ERROR: Invalid parameter ${1}"
    exit 1
  fi
  shift
done

# Determine valid merges
merges=""
prev_env=""
for env in ${taito_environments}
do
  env="${env/prod/master}"
  if [[ ${env} != "feat"* ]]; then
    if [[ ${prev_env} ]]; then
      merges="${merges} ${prev_env}->${env} "
    fi
    prev_env="${env}"
  fi
done

# Determine source branch
if [[ ! ${source} ]]; then
  source=$(git symbolic-ref --short HEAD)
fi

# Determine destination branch
if [[ ! ${dest} ]]; then
  dest=$(echo "${merges}" | sed "s/.*${source}->\([^[:space:]]*\).*/\1/")
fi

# Validate arguments
if [[ ! "${merges}" =~ .*${source}-.*\>${dest}.* ]]; then
  echo "Merging from ${source} to ${dest} is not allowed."
  echo "Changes must be merged from one environment to another in this order:"
  echo "${taito_environments}"
  exit 1
fi

# Execute all merges
source_found=false
for merge in ${merges[@]}
do
  if [[ "${merge}" == "${source}->"* ]] || [[ "${source_found}" ]]; then
    source_found=true
    s="${merge%->*}"
    d="${merge##*->}"
    echo "${s}->${d} ${git_push_options}"

    "${taito_cli_path}/util/execute-on-host-fg.sh" "\
    echo && \
    echo \"Merging ${s} -> ${d} ${git_push_options}\" && \
    echo \"Do you want to continue (Y/n)?\" && \
    read -r confirm && \
    if ! [[ ${confirm:-y} =~ ^[Yy]*$ ]]; then
      exit 130
    fi && \
    echo Merging... && \
    git fetch origin ${s}:${d} && \
    git push --no-verify ${git_push_options} origin ${d} || \
    echo 'NOTE: You can do force push with --force if you really want to overwrite all changes on branch ${d}' \
    "

  fi
  if [[ "${merge}" == *"->${dest}" ]]; then
    break
  fi
done
echo

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
