#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "terraform" "${name}" \
  "Destroy zone by running terraform scripts"
then
  (
    export TF_LOG_PATH="./terraform.log"
    # shellcheck disable=SC1090
    . "${taito_cli_path}/plugins/terraform/util/env.sh" && \
    cd "./terraform" && \
    terraform init && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform destroy
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
