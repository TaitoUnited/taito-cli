#!/bin/bash

project_id=$1
organization_id=$2

if [[ ${project_id} ]] && ! gcloud projects describe "${project_id}" &> /dev/null; then
  billing_var="gcp_billing_account_${taito_organization:-}"
  billing_id=${!billing_var:-$taito_provider_billing_account_id}
  if [[ ! ${billing_id} ]]; then
    echo "Enter billing account id for the new Google Cloud project '${project_id}':"
    read -r billing_id
  else
    if ! "$taito_util_path/confirm.sh" "Create new Google Cloud project '${project_id:?}'?"
    then
      billing_id=
    fi
  fi

  if [[ ${billing_id} ]] && [[ ${#billing_id} -gt 10 ]]; then
    gcloud projects create "${project_id:?}" \
      "--organization=${organization_id:?}" && \
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