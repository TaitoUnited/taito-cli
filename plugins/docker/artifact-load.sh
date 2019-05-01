#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_project:?}"

type=$1
if [[ $type == "tester" ]]; then
  file_suffix="-tester.docker"
  image_prefix="${taito_project}-"
  image_suffix="-tester:latest"
else
  file_suffix=".docker"
  image_prefix="TODO"
  image_suffix="TODO"
fi

(
  ${taito_setv:?}
  ls -1 *${file_suffix} | sed "s/${file_suffix}//" | xargs -L1 sh -c \
    "docker load -input \${0}${file_suffix} ${image_prefix}\${0}${image_suffix}"
)

# Call next command on command chain
"${taito_util_path}/util/call-next.sh" "${@}"
