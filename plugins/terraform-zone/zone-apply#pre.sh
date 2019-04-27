#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "terraform" "${name}" \
  "Apply changes by running terraform scripts"
then
  (
    if [[ -f "./terraform/terraform.tfstate" ]]; then
      echo "Your Terraform state is currently located on local disk. You should"
      echo "configure remote backend in ./terraform/main.tf before continuing."
      echo "If you already have configured the remote state, you can delete"
      echo "./terraform/terraform.tfstate and ./terraform/terraform.tfstate.backup"
      echo "from your local disk."
      echo
      echo "Do you want to continue anyway (y/N)?"
      read -r confirm
      if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
        exit 130
      fi
    fi

    export TF_LOG_PATH="./terraform.log"
    # shellcheck disable=SC1090
    . "${taito_cli_path}/plugins/terraform/util/env.sh" && \
    cd "./terraform" && \
    terraform init && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform apply

    if [[ "${taito_zone_initial_database_password:-}" ]]; then
      echo
      echo "--- CHANGE DATABASE MASTER PASSWORD ---"
      echo
      echo "Your database master password was initially set to the initial password"
      echo "configured in taito-config.sh. The initial password is stored both in"
      echo "taito-config.sh and in terraform state as plain text. Therefore"
      echo "you should change the database administrator password for every"
      echo "database instance that was created, if you have not done so already."
      echo
      echo "You most likely can change the password on cloud provider web console."
      echo "Look for modify button or users tab in the database section."
      echo
      databases_link="$(taito -q link-databases | grep -v '^\s*$')"
      if [[ ${databases_link} ]]; then
        echo "Press enter to open the web console at ${databases_link}"
        read -r
        "${taito_util_path}/browser.sh" "${databases_link}"
      fi
      echo "Press enter once the password has been changed"
      read -r
    fi
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
