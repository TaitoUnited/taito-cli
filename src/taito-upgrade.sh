#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_cli_path:?}"
: "${taito_image:?}"

# Pull latest version of taito bash script
echo "Pulling taito-cli directory from git: ${taito_cli_path}"
(cd "${taito_cli_path}" && git pull)

# Pull taito-cli docker image
echo "Pulling taito-cli docker image from registry: ${taito_image}"
docker pull "${taito_image}"

# Prepare taito-new image for modificaions
docker rm taito-save taito-new &> /dev/null
docker create --name taito-new "${taito_image}"

echo "Creating taito user with local user uid and gid on taito-cli image"
docker start taito-new &> /dev/null
docker exec -it taito-new /bin/sh -c "\
  /taito-cli-deps/tools/user-create.sh taito $(id -u) $(id -g) && \
  /taito-cli-deps/tools/user-init.sh taito"

# NOTE: just in case
sleep 3

# Copy credentials from old image
if docker create --name taito-save "${taito_image}save" &> /dev/null; then
  echo "Copying credentials from the old taito-cli image"
  mkdir -p ~/.taito/save/root &> /dev/null
  mkdir -p ~/.taito/save/taito &> /dev/null

  docker cp taito-save:/home/taito/.config ~/.taito/save/taito &> /dev/null
  docker cp taito-save:/home/taito/.kube ~/.taito/save/taito &> /dev/null
  docker cp taito-save:/root/.config ~/.taito/save/root &> /dev/null
  docker cp taito-save:/root/.kube ~/.taito/save/root &> /dev/null
  docker cp taito-save:/root/admin_creds.enc ~/.taito/save/root &> /dev/null
  docker cp ~/.taito/save/taito/.config taito-new:/home/taito &> /dev/null
  docker cp ~/.taito/save/taito/.kube taito-new:/home/taito &> /dev/null
  docker cp ~/.taito/save/root/.config taito-new:/root &> /dev/null
  docker cp ~/.taito/save/root/.kube taito-new:/root &> /dev/null
  docker cp ~/.taito/save/root/admin_creds.enc taito-new:/root &> /dev/null

  rm -rf ~/.taito/save
fi

echo "Committing changes to taito-cli image"
docker commit taito-new "${taito_image}" &> /dev/null
docker stop taito-new &> /dev/null
docker image tag "${taito_image}" "${taito_image}save"
docker rm taito-save taito-new &> /dev/null
echo "DONE!"
