#!/bin/bash

database_id="${gcloud_project}:${gcloud_region}:${database_instance}"

if [[ $1 == "true" ]]; then
  # Run in background
  (
    ${taito_setv:?}
    cloud_sql_proxy "-instances=${database_id}=tcp:${gcloud_sql_proxy_port}" \
      &> /tmp/proxy-out.tmp &
    sleep 3
    cat /tmp/proxy-out.tmp
  )
else
  if [[ "${taito_docker}" == "true" ]]; then
    bind_address="0.0.0.0"
  else
    bind_address="127.0.0.1"
  fi

  echo "BIND ADDRESS: ${bind_address}"

  (
    ${taito_setv:?}
    cloud_sql_proxy \
      "-instances=${database_id}=tcp:${bind_address}:${gcloud_sql_proxy_port}"
  )
fi
