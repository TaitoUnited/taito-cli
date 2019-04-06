#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ -z $1 ]]; then
  echo "Fetching latest image tag from build history..."
  # Detetermine target image automatically
  export taito_target_image
  taito_target_image=$( \
    gcloud -q builds list \
      --sort-by="~createTime" --format="value(images)" --limit=1 \
      --filter=" \
        status:SUCCESS AND \
        source.repoSource.repoName~.*${taito_project:?} AND \
        source.repoSource.branchName:${taito_branch:?}" | \
      sed "s/^.*:\([^;]*\)*;.*$/\1/" \
  )
  echo "Using tag: ${taito_target_image}"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
