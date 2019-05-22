#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_util_path:?}"
: "${taito_image:?}"
: "${taito_home_path:?}"

# Make sure that mounted directories exist
echo "Checking mount directories"
mkdir -p "${taito_home_path}/.taito"
mkdir -p "${taito_home_path}/.ssh"
mkdir -p "${taito_home_path}/.terraform.d"

# Pull latest version of taito bash script
echo "Pulling taito-cli directory from git: ${taito_cli_path}"
(
  cd "${taito_cli_path}"
  branch=$(git branch | grep \* | cut -d ' ' -f2)
  if [[ ${branch} != "master" ]]; then
    echo
    echo "WARNING! You are currently using ${branch} branch of taito-cli."
    echo "Checkout the master branch instead (Y/n)?"
    read -r confirm
    if [[ ${confirm} =~ ^[Yy]*$ ]]; then
      git checkout master && \
      git branch --set-upstream-to=origin/master master
    fi
  fi
  git pull
)

# Pull taito-cli docker image
echo "Pulling taito-cli docker image from registry: ${taito_image}"
docker pull "${taito_image}"

# Prepare taito-new image for modificaions
docker rm taito-save taito-new &> /dev/null

echo "Creating taito user with local user uid and gid on taito-cli image"
docker_run_flags=
if [[ -f ${HOME}/.taito/install.sh ]]; then
  docker_run_flags="-v ${HOME}/.taito/install.sh:/taitoinstall.sh"
fi
docker run -it --name taito-new --entrypoint /bin/bash ${docker_run_flags} \
  "${taito_image}" -c "
  /taito-cli-deps/tools/user-create.sh taito $(id -u) $(id -g)
  /taito-cli-deps/tools/user-init.sh taito
  if [[ -f /taitoinstall.sh ]]; then
    echo
    echo --- Executing \~/.taito/install.sh ---
    echo
    chmod +x /taitoinstall.sh
    /taitoinstall.sh
    echo
    echo --- Done executing \~/.taito/install.sh ---
    echo
  fi
"

# Copy credentials from old image
if docker create --name taito-save "${taito_image}save" &> /dev/null; then
  echo "Copying settings from the old taito-cli image"
  rm -rf ~/.taito/save &> /dev/null
  mkdir -p ~/.taito/save &> /dev/null

  docker cp taito-save:/home/taito ~/.taito/save &> /dev/null
  docker cp taito-save:/root ~/.taito/save &> /dev/null

  # a quick fix to preserve repositories installed in user-init.sh
  rm -f ~/.taito/save/taito/.helm/repository/repositories.yaml
  rm -f ~/.taito/save/root/.helm/repository/repositories.yaml

  docker cp ~/.taito/save/taito taito-new:/home &> /dev/null
  docker cp ~/.taito/save/root taito-new:/ &> /dev/null

  rm -rf ~/.taito/save
fi

echo "Committing changes to taito-cli image"
docker commit taito-new "${taito_image}" &> /dev/null
docker stop taito-new &> /dev/null
docker image tag "${taito_image}" "${taito_image}save"
docker rm taito-save taito-new &> /dev/null

echo "Deleting old temp files"
rm -rf "${taito_home_path}/.taito/tmp" &> /dev/null

echo
echo "DONE! Your taito-cli has been upgraded."
echo
echo "NOTE: It is recommended that once in while you also check that your"
echo "organizational settings are up-to-date. They are located at '~/.taito'"
echo "directory. You may find the recommended settings by running"
echo "'taito open conventions' or 'taito -o ORGANIZATION open conventions'."
echo
