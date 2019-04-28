#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"

ignore_build_id=${1}

echo "Canceling all previous ongoing builds targetting branch ${taito_branch:?}"
echo

(
  ${taito_setv:?}
  gcloud -q builds list --ongoing \
    --filter=" \
      source.repoSource.repoName~.*${taito_project:?} AND \
      source.repoSource.branchName:${taito_branch:?}" | \
  grep -v "${ignore_build_id:-OR_DO_NOT_IGNORE}" | \
  cut -d ' ' -f 1 | \
  xargs -L1 gcloud builds cancel &> /dev/null && \
  echo CANCELLED
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
