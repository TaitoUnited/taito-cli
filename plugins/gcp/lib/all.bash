#!/bin/bash

function gcp::authenticate () {
  local type=${1}
  local account
  account=$(gcloud config get-value account 2> /dev/null)

  if [[ ${account} ]]; then
    echo "You are already authenticated as ${account}."
    echo "You can reauthenticate with 'taito auth:${taito_env} reset'."
    echo
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
      [[ ${type} == "init" ]] || [[ ${type} == "reset" ]]
  then
    echo "gcloud init"
    echo
    echo -e "${NOTEs}"
    echo "---------------------------------------------------------------"
    echo "You can select anything as your default GCP project and region."
    echo "Taito CLI will always use the values defined in taito config"
    echo "files instead of the default GCP settings you have selected"
    echo "during authentication."
    echo "---------------------------------------------------------------"
    echo -e "${NOTEe}"
    echo
    echo "Press enter to continue to authentication"
    read -r
    # TODO run 'gcloud auth revoke ${account}' ?
    (${taito_setv:?}; gcloud init --console-only)
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
      [[ ${type} == "login" ]] || [[ ${type} == "reset" ]]
  then
    echo "gcloud auth application-default login"
    # TODO run 'gcloud auth revoke ${account}' ?
    (${taito_setv:?}; gcloud auth application-default login)
  fi

  if [[ -n "${kubernetes_name:-}" ]]; then
    if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]] || [[ ${type} == "reset" ]]
    then
      "${taito_cli_path}/plugins/gcp/util/get-credentials-kube" || (
        echo "WARNING: Kubernetes authentication failed."
        echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
      )
    fi
  fi
}

function gcp::authenticate_on_kubernetes () {
  (${taito_setv:?}; gcloud container clusters get-credentials "${kubernetes_name}" \
    --project "${taito_zone}" --zone "${taito_provider_zone}")
}

function gcp::db_proxy_start () {
  if [[ ${gcp_db_proxy_enabled:-} != "false" ]]; then
    local database_id="${taito_zone:?}:${taito_provider_region:?}:${database_instance:?}"

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
      local bind_address
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
}

function gcp::db_proxy_stop () {
  if [[ ${gcp_db_proxy_enabled:-} != "false" ]]; then
    # kill cloud_sql_proxy
    (${taito_setv:?}; pgrep cloud_sql_proxy | xargs kill)
  fi
}

function gcp::ensure_project_exists () {
  local project_id=$1
  local organization_id=$2

  if [[ ${project_id} ]] && ! gcloud projects describe "${project_id}" &> /dev/null; then
    local billing_var="gcp_billing_account_${taito_organization:-}"
    local billing_id=${!billing_var:-$taito_provider_billing_account_id}
    if [[ ! ${billing_id} ]]; then
      echo "Enter billing account id for the new Google Cloud project '${project_id}':"
      read -r billing_id
    else
      if ! taito::confirm "Create new Google Cloud project '${project_id:?}'?"
      then
        billing_id=
      fi
    fi

    if [[ ${billing_id} ]] && [[ ${#billing_id} -gt 10 ]]; then
      gcloud projects create "${project_id:?}" \
        "--organization=${organization_id:?}"
      gcloud beta billing projects link "${project_id:?}" \
        --billing-account "${billing_id}"

      # NOTE: hack for https://github.com/terraform-providers/terraform-provider-google/issues/2605
      if [[ $project_id == "${taito_uptime_namespace_id:-}" ]]; then
        read -t 1 -n 10000 discard || :
        echo "You need to create Stackdriver workspace manually by opening Google Project"
        echo "'$project_id' and choosing Monitoring from the menu."
        echo
        echo "Press enter once done."
        read -r
      fi
    else
      exit 130
    fi
  fi
}
