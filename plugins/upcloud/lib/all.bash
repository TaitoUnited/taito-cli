#!/bin/bash

function upcloud::authenticate () {
  local type="${1//--/}"

  echo "TODO: Authenticate to UpCloud"
  read -r

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
  (
    echo "TODO: Authenticate to UpCloud Managed Kubernetes"
    read -r
  )
}
