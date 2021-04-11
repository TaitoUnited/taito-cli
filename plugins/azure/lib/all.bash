#!/bin/bash

function azure::authenticate () {
  local options=" ${*} "
  local do_reset=false

  if [[ ${options} == *" --reset "* ]]; then
    do_reset=true
  fi

  if ! az account show &> /dev/null || ${do_reset}; then
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
    echo "Authenticating to Kubernetes"
    azure::authenticate_on_kubernetes ${do_reset} || (
      echo
      echo "--------------------------------------------------------------------"
      echo "WARNING: Kubernetes authentication failed. Note that Kubernetes"
      echo "authentication failure is OK if the Kubernetes cluster does"
      echo "not exist yet."
      echo "--------------------------------------------------------------------"
    )
  fi
}

function azure::authenticate_on_acr () {
  taito::executing_start
  az acr login --name "${taito_container_registry%%.*}" > "${taito_vout:-}"
}

function azure::authenticate_on_kubernetes () {
  taito::executing_start
  local do_reset=$1

  local opts=
  if [[ ${do_reset} == true ]]; then
    opts="${opts} --overwrite-existing"
  fi
  if [[ ${kubernetes_admin} ]]; then
    opts="${opts} --admin"
  fi

  yes n | az aks get-credentials \
    ${opts} \
    --name "${kubernetes_name}" \
    --resource-group "${azure_resource_group:-$taito_zone}" &> "${taito_vout:-}"

  # Trigger authentication prompt
  kubectl version
}

function azure::ensure_resource_group_exists () {
  local name=${1:?}
  local region=${2:?}
  local subscription=${3:?}
  local exists=$(
    az group exists \
      --name "${name}" \
      --subscription "${subscription}"
  )
  if [[ ${exists} == "true" ]]; then return; fi

  echo "Creating resource group ${name}"
  taito::executing_start
  az group create \
    --name "${name}" \
    --location "${region}" \
    --subscription "${subscription}"
}
