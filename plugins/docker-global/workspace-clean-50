#!/bin/bash
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "\
echo Stopping containers:; \
docker stop \$(docker ps -a -q); \
sleep 2; \
echo ; \
echo docker volume prune: ; \
docker volume prune; \
echo ; \
echo docker system prune: ; \
docker system prune -a --filter 'label!=fi.taitounited.taito-cli' ; \
docker rmi \$(docker images | grep '<none>' | tr -s ' ' | cut -d ' ' -f 3)"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
