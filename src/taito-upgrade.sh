#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_cli_path:?}"
: "${taito_image:?}"

echo

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
  echo "Copying settings from the old taito-cli image"
  rm -rf ~/.taito/save &> /dev/null
  mkdir -p ~/.taito/save &> /dev/null

  docker cp taito-save:/home/taito ~/.taito/save &> /dev/null
  docker cp taito-save:/root ~/.taito/save &> /dev/null
  docker cp ~/.taito/save/taito taito-new:/home &> /dev/null
  docker cp ~/.taito/save/root taito-new:/ &> /dev/null

  rm -rf ~/.taito/save
fi

echo "Committing changes to taito-cli image"
docker commit taito-new "${taito_image}" &> /dev/null
docker stop taito-new &> /dev/null
docker image tag "${taito_image}" "${taito_image}save"
docker rm taito-save taito-new &> /dev/null
echo "DONE!"
echo
echo "NOTE: Your taito-cli has been upgraded. It is recommended that once in while"
echo "you also check that your organizational settings are up-to-date."
echo "They are located at '~/.taito' directory. Running"
echo "'taito open conventions' or 'taito -o ORGANIZATION open conventions'"
echo "may give you some more details."
echo
