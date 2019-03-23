#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"

ignore_build_id=${1}

full_repo_name="${taito_vc_repository}"
if [[ ${taito_env} == "prod" ]]; then
  branch_name="master"
else
  branch_name=${taito_env}
fi

echo "Canceling all previous ongoing builds targetting branch ${branch_name}"
echo

(
  ${taito_setv:?}
  gcloud builds list --ongoing | \
    grep "${full_repo_name}@${branch_name}" | \
    grep -v "${ignore_build_id:-OR_DO_NOT_IGNORE}" | \
    cut -d ' ' -f 1 | \
    xargs -L1 gcloud builds cancel &> /dev/null && \
    echo CANCELLED
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
