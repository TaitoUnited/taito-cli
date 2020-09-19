#!/bin/bash

function do::authenticate () {
  local options=" ${*} "

  if ! doctl account get &> /dev/null || \
     [[ ${options} == *" --reset "* ]]; then
    echo "Provide access keys with proper access rights. Instructions:"
    echo "https://www.digitalocean.com/docs/api/create-personal-access-token/"
    echo
    echo "Press enter to open the Digital Ocean control panel for retrieving the access keys"
    read -r
    taito::open_browser "https://cloud.digitalocean.com/account/api/tokens"
    echo
    echo "Note: The inputted API key won't be shown in the terminal."
    echo
    rm -f ~/.config/doctl/config.yaml &> /dev/null || :
    doctl auth init
    # TODO: docker-commit is called twice on 'taito auth'
    taito::commit_changes
  else
    echo "Already authenticated."
    echo "You can reauthenticate with 'taito auth --reset'."
  fi

  if [[ ! -f ~/.config/doctl/spaces_secret_key ]] || \
     [[ ${options} == *" --reset "* ]]; then
    echo
    echo "Enter Spaces access and secret key. You can retrieve them from Digital Ocean"
    echo "web user interface."
    echo
    echo "Spaces access id:"
    read -r spaces_access_id
    echo "${spaces_access_id}" > ~/.config/doctl/spaces_access_id
    echo "Spaces secret key:"
    read -r -s spaces_secret_key
    echo "${spaces_secret_key}" > ~/.config/doctl/spaces_secret_key
  else
    echo "Spaces secret key already set."
    echo "You can reset it with 'taito auth --reset'."
  fi

  if [[ ${kubernetes_name:-} ]]; then
    do::authenticate_on_kubernetes || (
      echo
      echo "--------------------------------------------------------------------"
      echo "WARNING: Kubernetes authentication failed. Note that Kubernetes"
      echo "authentication failure is OK if the Kubernetes cluster does"
      echo "not exist yet."
      echo "--------------------------------------------------------------------"
    )
  fi
}

function do::authenticate_on_kubernetes () {
  taito::executing_start
  doctl kubernetes cluster kubeconfig save "${kubernetes_name}" > "${taito_vout:-}"
}
