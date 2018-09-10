#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_cli_path:?}"
: "${taito_image:?}"

# Pull latest version of taito bash script
(cd "${taito_cli_path}" && git pull)

# Pull taito-cli docker image
docker pull "${taito_image}"

# Prepare taito-new image for modificaions
docker rm taito-save taito-new &> /dev/null
docker create --name taito-new "${taito_image}"

# Copy credentials from old image
if docker create --name taito-save "${taito_image}save" &> /dev/null; then
  echo "Copying credentials from the old image."
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

echo "Changing uid and gid to match the current user id"
docker start taito-new &> /dev/null
docker exec -it taito-new /bin/sh -c \
  "groupadd --gid $(id -g) taitogroup 2> /dev/null || usermod --uid $(id -u) taito"
sleep 3

echo "Committing changes to taito image"
docker commit taito-new "${taito_image}" &> /dev/null
docker stop taito-new &> /dev/null
docker image tag "${taito_image}" "${taito_image}save"
docker rm taito-save taito-new &> /dev/null
echo "DONE!"
