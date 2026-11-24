#!/bin/bash

function upcloud::authenticate () {
  local type="${1//--/}"

  if [[ ${taito_commands_only_chain:-} == *"terraform/"* ]] || [[ ${taito_commands_only_chain:-} == *"terraform-zone/"* ]]; then
    current_public_ip=$(curl -s https://ifconfig.me)

    echo "If you plan to execute Terraform, enter your UpCloud API token. Otherwise leave it empty."
    echo "Prefer a short lived API token limited to your current IP address ${current_public_ip}."
    echo
    echo "UpCloud API token:"
    read -r -s UPCLOUD_TOKEN
    export UPCLOUD_TOKEN
  fi

  if [[ ${upcloud_kubernetes_enabled:-} != "false" ]] && \
     [[ ${kubernetes_name:-} ]]; then
    if [[ ${type} == "" ]] || \
       [[ ${type} == "cluster" ]] || \
       [[ ${type} == "reset" ]]
    then
      upcloud::authenticate_on_kubernetes || (
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

function upcloud::authenticate_on_kubernetes () {
  # (
  #   echo "TODO: Authenticate to UpCloud Managed Kubernetes"
  #   read -r
  # )
  return;
}
