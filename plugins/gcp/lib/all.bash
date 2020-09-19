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
    echo
    echo "On auth reset, you should always re-initialize the default"
    echo "configuration:"
    echo "[1] Re-initialize this configuration [default] with new settings"
    echo "---------------------------------------------------------------"
    taito::print_note_end
    echo
    echo "Press enter to continue once you have read the message above."
    read -r
    echo "Did you really read the message? Press enter once you have read it."
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
      gcp::authenticate_on_kubernetes || (
        echo
        echo "--------------------------------------------------------------------"
        echo "WARNING: Kubernetes authentication failed. Note that Kubernetes"
        echo "authentication failure is OK if the Kubernetes cluster does"
        echo "not exist yet."
        echo "--------------------------------------------------------------------"
      )
    fi
  fi
}

function gcp::authenticate_on_kubernetes () {
  (
    local gopts="--zone ${taito_provider_zone:?}"
    if [[ ${kubernetes_regional:-} == "true" ]]; then
      gopts="--region ${taito_provider_region:?}"
    fi

    taito::executing_start
    gcloud container clusters get-credentials \
      "${kubernetes_name}" \
      --project "${taito_zone:?}" \
      ${gopts}
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
          "-instances=${database_id}=tcp:${taito_db_proxy_bind_address}:${database_port}"
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
        "--organization=${organization_id:-}"

      echo
      echo "Enabling billing for project ${project_id}"
      gcloud beta billing projects link "${project_id:?}" \
        --billing-account "${billing_id}"

      echo
      echo "Setting user rights for project ${project_id}"
      gcp::grant_role "${project_id}" roles/owner \
        "$(taito::print_variable taito_resource_namespace_owners true)"
      gcp::grant_role "${project_id}" roles/editor \
        "$(taito::print_variable taito_resource_namespace_editors true)"
      gcp::grant_role "${project_id}" roles/viewer \
        "$(taito::print_variable taito_resource_namespace_viewers true)"

      if [[ ${taito_state_bucket:-} == "taito_resource_namespace_prefix_sha1sum" ]]; then
        echo
        echo "Creating storage bucket for storing state"
        gsutil mb \
          -p "${taito_resource_namespace_id:?}" \
          -l "${taito_provider_region:?}" \
          "gs://${taito_resource_namespace_prefix_sha1sum:?}"

        # local storage_devs
        # storage_devs=$(
        #   taito::print_variable template_default_project_developers true | \
        #   sed 's/\>/:objectAdmin/g'
        # )
        # if [[ $storage_devs ]]; then
        #   echo
        #   echo "Granting user rights for the storage bucket"
        #   gsutil iam ch ${storage_devs} gs://ex-bucket
        # fi
      fi

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

function gcp::publish_current_target_assets () {
  if [[ -f ./taitoflag_images_exist ]] || ( \
     [[ ${taito_mode:-} == "ci" ]] && [[ ${ci_exec_build:-} == "false" ]] \
    ); then
    return
  fi

  # TODO: make assets and project buckets + path prefix configurable
  image_tag="${1}"
  if taito::is_current_target_of_type "function"; then
    # Publish function zip package to projects bucket
    # TODO: not tested at all
    source="./tmp/${taito_target:?}.zip"
    dest="gs://${taito_functions_bucket:?}/${taito_functions_path:?}/${image_tag}/${taito_target}.zip"
    options=""
  elif taito::is_current_target_of_type "static_content" &&
       [[ ${taito_cdn_project_path:-} ]] &&
       [[ ${taito_cdn_project_path} != "-" ]]
  then
    # Publish static assets to assets bucket
    source="./tmp/${taito_target}/service"
    dest="gs://${taito_static_assets_bucket:?}/${taito_static_assets_path:?}/${image_tag}/${taito_target}"
    options="-r"
  else
    echo "No need for copying assets to storage bucket"
  fi

  if [[ ${source} ]]; then
    echo "Copying ${taito_target} assets to ${dest}"
    taito::executing_start
    gsutil cp ${options} "${source}" "${dest}"
  fi
}
