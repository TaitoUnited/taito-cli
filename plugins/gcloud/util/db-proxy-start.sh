#!/bin/bash
: "${taito_verbose:?}"
: "${taito_vout:?}"

if [[ ${gcloud_db_proxy_enabled:-} != "false" ]]; then
  database_id="${taito_zone:?}:${taito_provider_region:?}:${database_instance:?}"

  if [[ $1 == "true" ]]; then
    # Run in background
    (
      ${taito_setv:?}
      cloud_sql_proxy "-instances=${database_id}=tcp:0.0.0.0:${database_port}" \
        &> /tmp/proxy-out.tmp &
    )
    # TODO: Implement robust wait for 'ready for connections' status
    sleep 1
    if [[ "${taito_verbose}" == "true" ]] || [[ "${taito_mode:-}" == "ci" ]]; then
      sleep 2
      cat /tmp/proxy-out.tmp
    fi
  else
    if [[ "${taito_docker}" == "true" ]]; then
      bind_address="0.0.0.0"
    else
      bind_address="127.0.0.1"
    fi

    echo "BIND ADDRESS: ${bind_address}" > ${taito_vout}

    (
      ${taito_setv:?}
      cloud_sql_proxy \
        "-instances=${database_id}=tcp:${bind_address}:${database_port}"
    )
  fi

fi
