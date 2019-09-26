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

  if [[ ${kubernetes_name:-} ]]; then
    do::authenticate_on_kubernetes ||
      echo -e "WARNING: Kubernetes authentication failed." \
        "\\nNOTE: Authentication failure is OK if the Kubernetes cluster does" \
        "not exist yet."
  fi
}

function do::authenticate_on_kubernetes () {
  taito::executing_start
  doctl kubernetes cluster kubeconfig save "${kubernetes_name}" > "${taito_vout:-}"
}
