#!/bin/bash

function gcp::authenticate () {
  local type=${1}
  local account
  account=$(gcloud config get-value account 2> /dev/null)

  if [[ ${account} ]]; then
    echo "You are already authenticated as ${account}."
    echo "You can reauthenticate with 'taito auth:${taito_target_env:?} reset'."
    echo
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
     [[ ${type} == "init" ]] || [[ ${type} == "reset" ]]
  then
    echo "gcloud init"
    echo
    taito::print_note_start
    echo "---------------------------------------------------------------"
    echo "You can select anything as your default GCP project and region."
    echo "Taito CLI will always use the values defined in taito config"
    echo "files instead of the default GCP settings you have selected"
    echo "during authentication."
    echo "---------------------------------------------------------------"
    taito::print_note_end
    echo
    echo "Press enter to continue to authentication"
    read -r
    # TODO run 'gcloud auth revoke ${account}' ?
    (taito::executing_start; gcloud init --console-only)
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
     [[ ${type} == "login" ]] || [[ ${type} == "reset" ]]
  then
    echo "gcloud auth application-default login"
    # TODO run 'gcloud auth revoke ${account}' ?
    (taito::executing_start; gcloud auth application-default login)
  fi

  if [[ ${gcp_kubernetes_enabled:-} != "false" ]] && \
     [[ ${kubernetes_name:-} ]]; then
    if [[ ${type} == "" ]] || \
       [[ ${type} == "cluster" ]] || \
       [[ ${type} == "reset" ]]
    then
      gcp::authenticate_on_kubernetes || \
        echo -e "WARNING: Kubernetes authentication failed." \
          "\\nNOTE: Authentication failure is OK if the Kubernetes cluster" \
          "does not exist yet."
    fi
  fi
}

function gcp::authenticate_on_kubernetes () {
  (
    taito::executing_start
    gcloud container clusters get-credentials \
      "${kubernetes_name}" \
      --project "${taito_zone:?}" \
      --zone "${taito_provider_zone:?}"
  )
}

function gcp::db_proxy_start () {
  if [[ ${gcp_db_proxy_enabled:-} != "false" ]]; then
    local database_id
    database_id="${taito_zone:?}:${taito_provider_region:?}:${database_instance:?}"

    echo "BIND ADDRESS: ${taito_db_proxy_bind_address:?}" > "${taito_vout:-}"

    if [[ $1 == "true" ]]; then
      # Run in background
      (
        taito::executing_start
        cloud_sql_proxy \
          "-instances=${database_id}=tcp:${taito_db_proxy_bind_address}:${database_port:?}" \
          &> /tmp/proxy-out.tmp &
      )
      # TODO: Implement robust wait for 'ready for connections' status
      sleep 1
      if [[ ${taito_verbose:?} == "true" ]] || \
         [[ ${taito_mode:-} == "ci" ]]
      then
        sleep 2
        cat /tmp/proxy-out.tmp
      fi
    else
      (
        taito::executing_start
        cloud_sql_proxy \
          "-instances=${database_id}=tcp:${bind_address}:${database_port}"
      )
    fi

  fi
}

function gcp::db_proxy_stop () {
  if [[ ${gcp_db_proxy_enabled:-} != "false" ]]; then
    # kill cloud_sql_proxy
    (taito::executing_start; pgrep cloud_sql_proxy | xargs kill)
  fi
}

function gcp::grant_role () {
  project=$1
  role=$2
  users=$3
  for user in ${users[@]}; do
    gcloud projects add-iam-policy-binding "${project_id}" \
      --member "${user}" --role "${role}"
  done
}

function gcp::ensure_project_exists () {
  local project_id=$1
  local organization_id=$2

  if [[ ${project_id} ]] && \
     ! gcloud projects describe "${project_id}" &> /dev/null
  then
    local billing_var="gcp_billing_account_${taito_organization:-}"
    local billing_id=${!billing_var:-$taito_provider_billing_account_id}
    if [[ ! ${billing_id} ]]; then
      echo -e "Enter billing account id for the new Google Cloud project" \
        "'${project_id}':"
      read -r billing_id
    else
      if ! taito::confirm "Create new Google Cloud project '${project_id:?}'?"
      then
        billing_id=
      fi
    fi

    if [[ ${billing_id} ]] && [[ ${#billing_id} -gt 10 ]]; then
      echo
      echo "Creating project ${project_id}"
      gcloud projects create "${project_id:?}" \
        "--organization=${organization_id:?}"

      echo
      echo "Enabling billing for project ${project_id}"
      gcloud beta billing projects link "${project_id:?}" \
        --billing-account "${billing_id}"

      echo
      echo "Setting user rights for project ${project_id}"
      gcp::grant_role "${project_id}" roles/owner \
        "$(taito::print_variable template_default_project_owners true)"
      gcp::grant_role "${project_id}" roles/editor \
        "$(taito::print_variable template_default_project_editors true)"
      gcp::grant_role "${project_id}" roles/viewer \
        "$(taito::print_variable template_default_project_viewers true)"

      # NOTE: hack for https://github.com/terraform-providers/terraform-provider-google/issues/2605
      if [[ $project_id == "${taito_uptime_namespace_id:-}" ]]; then
        read -t 1 -n 10000 || :
        echo -e "You need to create Stackdriver workspace manually by opening" \
          "Google Project\\n'$project_id' and choosing Monitoring from the menu."
        echo
        echo "Press enter once done."
        read -r
      fi
    else
      exit 130
    fi
  fi
}
