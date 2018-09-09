#!/bin/bash
: "${taito_verbose:?}"
: "${taito_vout:?}"

if [[ -n "${database_proxy_port:-}" ]]; then
  database_id="${gcloud_project:-}:${gcloud_region:-}:${database_instance:-}"

  if [[ $1 == "true" ]]; then
    # Run in background
    cloud_sql_proxy "-instances=${database_id}=tcp:${database_proxy_port}" &
    # TODO put back
    # (
    #   ${taito_setv:?}
    #   cloud_sql_proxy "-instances=${database_id}=tcp:${database_proxy_port}" \
    #     &> /tmp/proxy-out.tmp &
    # )
    # if [[ "${taito_verbose}" == "true" || "${taito_mode:-}" == "ci" ]]; then
    #   sleep 3
    #   cat /tmp/proxy-out.tmp
    # fi
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
        "-instances=${database_id}=tcp:${bind_address}:${database_proxy_port}"
    )
  fi

fi
