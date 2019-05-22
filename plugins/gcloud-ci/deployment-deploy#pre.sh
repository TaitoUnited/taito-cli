#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_zone:?}"

if [[ -z $1 ]]; then
  echo "Fetching latest image tag from build history..."
  # Detetermine target image automatically
  export taito_target_image
  ${taito_setv:?}
  taito_target_image=$( \
    gcloud -q --project "${taito_zone}" builds list \
      --sort-by="~createTime" --format="value(images)" \
      --filter=" \
        status:SUCCESS AND \
        source.repoSource.repoName~.*${taito_project:?} AND \
        source.repoSource.branchName:${taito_branch:?}" | \
      head -1 | \
      sed "s/^.*:\([^;]*\)*;.*$/\1/" \
  )
  echo "Using tag: ${taito_target_image}"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
