#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_target_env:?}"

image_tag=$1

function cleanup {
  rm -rf "tmp/ci/$taito_target_env" &> /dev/null || :
}

(
  trap cleanup EXIT
  # TODO: fetch secrets from host instead
  cp -r secrets "tmp/ci/$taito_target_env" &> /dev/null || :
  cd "tmp/ci/$taito_target_env"
  echo "Image tag: ${image_tag}"
  "${taito_util_path}/ssh-agent.sh" "./local-ci.sh ${taito_target_env} ${image_tag}"
)

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
