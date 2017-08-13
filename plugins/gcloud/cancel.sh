#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"

ignore_build_id=${1}

full_repo_name="github-taitounited-${taito_repo_name}"
if [[ ${taito_env} == "prod" ]]; then
  branch_name="master"
else
  branch_name=${taito_env}
fi

echo
echo "### gcloud - cancel: Cancel all previous ongoing builds targetting branch ${branch_name} ###"
echo

gcloud beta container builds list --ongoing | \
  grep "${full_repo_name}@${branch_name}" | \
  grep -v "${ignore_build_id}" | \
  cut -d ' ' -f 1 | \
  xargs -L1 gcloud container builds cancel

echo
echo "NOTE: All fails on cancel operation are intentionally ignored. Perhaps nothing to cancel, and cancelling is not that important anyway."

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
