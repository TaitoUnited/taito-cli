#!/bin/bash

if [[ "${taito_host_uname:?}" == *"_NT"* ]]; then
  # Mitigate slow volume mounts on Windows with rsync
  echo "export DC_PATH='/rsync'"
  echo "export DC_COMMAND='sh -c \"cp -rf /rsync/service/. /service; (while true; do rsync -rtq /rsync/service/. /service; sleep 2; done) &\" '"
else
  echo "export DC_PATH= "
  echo "export DC_COMMAND= "
fi
