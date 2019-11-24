#!/bin/bash

function azure::authenticate () {
  local options=" ${*} "

  if ! az account show &> /dev/null || \
     [[ ${options} == *" --reset "* ]]; then
    echo "Provide access to your Azure account."
    echo
    echo "Press enter to start the login process."
    echo "This'll open the authentication page automatically."
    read -r
    taito::open_browser "https://microsoft.com/devicelogin"
    az login --tenant "${taito_provider_tenant:-$taito_provider_org_id}"
    az account set --subscription "${taito_provider_billing_account_id:?}"
    # TODO: docker-commit is called twice on 'taito auth'
    taito::commit_changes
  else
    echo "Already authenticated."
    echo "You can reauthenticate with 'taito auth --reset'."
  fi

  if [[ ${kubernetes_name:-} ]]; then
    azure::authenticate_on_kubernetes ||
      echo -e "WARNING: Kubernetes authentication failed." \
        "\\nNOTE: Authentication failure is OK if the Kubernetes cluster does" \
        "not exist yet."
  fi
}

function azure::authenticate_on_acr () {
  taito::executing_start
  az acr login --name "${taito_container_registry%.*}" > "${taito_vout:-}"
}

function azure::authenticate_on_kubernetes () {
  taito::executing_start
  az aks get-credentials \
    --name "${kubernetes_name}" \
    --resource-group "${azure_resource_group:-$taito_zone}" \
    --overwrite-existing > "${taito_vout:-}"
}
