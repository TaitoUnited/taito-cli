#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_branch:?}"
: "${taito_vc_repository_url:?}"
: "${taito_target_env:?}"

image_tag=$1
if [[ ! ${image_tag} ]]; then
  image_tag=$(git rev-parse "${taito_branch:?}")
fi

echo "Do you want to execute CI/CD for ${taito_target_env} (Y/n)?"
read -r confirm
if [[ ${confirm:-y} =~ ^[Yy]*$ ]]; then
  "${taito_util_path}/execute-on-host-fg.sh" "
    function cleanup {
      rm -rf tmp/ci/$taito_target_env &> /dev/null || :
    }
    cleanup
    trap cleanup EXIT
    mkdir -p tmp/ci
    git clone --single-branch --branch $taito_branch git@${taito_vc_repository_url/\//:} tmp/ci/$taito_target_env
    taito -r -c ci-run-continue:$taito_target_env ${image_tag}
  "
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
