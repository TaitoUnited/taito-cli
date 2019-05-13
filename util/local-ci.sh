#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_branch:?}"

env=${taito_env:?}
image_tag=$1
if [[ ! ${image_tag} ]]; then
  image_tag=$(git rev-parse "${taito_branch:?}")
fi

echo "Do you want to execute CI/CD for ${env} (Y/n)?"
read -r confirm
if [[ ${confirm:-y} =~ ^[Yy]*$ ]]; then
  rm -f ./taitoflag* &> /dev/null
  echo "Image tag: ${image_tag}"
  ssh-agent bash -c "./local-ci.sh ${env} ${image_tag}"
fi
