#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_cli_path:?}"
: "${taito_image:?}"

# Pull latest version of taito bash script
(cd "${taito_cli_path}" && git pull)

# Pull taito-cli docker image
docker pull "${taito_image}"

# Copy credentials from old image
docker rm taito-save taito-new &> /dev/null
if docker create --name taito-save "${taito_image}save" &> /dev/null; then
  docker create --name taito-new "${taito_image}"
  echo "Copying credentials from the old image."
  mkdir -p ~/.taito/save &> /dev/null

  docker cp taito-save:/root/.config ~/.taito/save
  docker cp taito-save:/root/.kube ~/.taito/save
  docker cp taito-save:/root/admin_creds.enc ~/.taito/save &> /dev/null
  docker cp ~/.taito/save/.config taito-new:/root
  docker cp ~/.taito/save/.kube taito-new:/root
  docker cp ~/.taito/save/admin_creds.enc taito-new:/root &> /dev/null

  docker commit taito-new "${taito_image}" &> /dev/null
  docker image tag "${taito_image}" "${taito_image}save"
  rm -rf ~/.taito/save
  docker rm taito-save taito-new &> /dev/null
  echo "DONE!"
fi
