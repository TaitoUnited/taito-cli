#!/bin/bash

function aws::expose_aws_options () {
  if [[ $AWS_ACCESS_KEY_ID ]]; then
    profile="env var key"
    aws_options=""
  else
    profile=${taito_provider_user_profile:-$taito_organization}
    profile=${profile:-default}
    aws_options="--profile $profile"
  fi
}

function aws::authenticate () {
  local options=" ${*} "

  aws::expose_aws_options

  if ! aws configure $aws_options list &> /dev/null || \
     [[ "${options}" == *" --reset "* ]]; then
    echo "Authenticating with profile name '$profile'."
    echo
    echo "Provide access keys with proper access rights. Instructions:"
    echo "https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration"
    echo
    echo "Recommended settings:"
    echo "- Access type: Programmatic access"
    echo "- Policies: AdministratorAccess (TODO)"
    echo "- Default region: ${taito_provider_region:-}"
    echo "- Default output format: text"
    echo
    echo "Press enter to open the AWS IAM console for retrieving the access keys"
    read -r
    taito::open_browser "https://console.aws.amazon.com/iam/home?#home"
    echo
    aws configure $aws_options
    # TODO: docker-commit is called twice on 'taito auth'
    taito::commit_changes
  else
    echo "Already authenticated with profile '$profile'."
    echo "You can reauthenticate with 'taito auth --reset'."
  fi

  if [[ -n "${kubernetes_name:-}" ]]; then
    "${taito_cli_path}/plugins/aws/util/get-credentials-kube" || (
      echo "WARNING: Kubernetes authentication failed."
      echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
    )
  fi

  # TODO authenticate also to ECR
  # echo
  # echo "Getting credentials for Elastic Container Registry"
  # "${taito_plugin_path}/util/get-credentials-ecr"
}

function aws::authenticate_on_ecr () {
  aws::expose_aws_options

  # NOTE: one-liner login to avoid passing password via CLI:
  # https://github.com/aws/aws-cli/issues/2875#issuecomment-487244855
  ${taito_setv:?}
  aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $6}' | docker login -u AWS --password-stdin $(aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $7}')
}

function aws::authenticate_on_kubernetes () {
  aws::expose_aws_options

  ${taito_setv:?}
  aws $aws_options eks \
    --region "${taito_provider_region}" update-kubeconfig \
    --name "${kubernetes_name}" \
    --alias "${kubernetes_name}" > ${taito_vout:-}
}
