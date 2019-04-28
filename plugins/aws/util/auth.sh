#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

options=" ${*} "

. "${taito_cli_path}/plugins/aws/util/aws-options.sh"

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
  "${taito_util_path}/browser.sh" "https://console.aws.amazon.com/iam/home?#home"
  echo
  aws configure $aws_options
  # TODO: docker-commit is called twice on 'taito auth'
  "${taito_util_path}/docker-commit.sh"
else
  echo "Already authenticated with profile '$profile'."
  echo "You can reauthenticate with 'taito auth --reset'."
fi

if [[ -n "${kubectl_name:-}" ]]; then
  "${taito_cli_path}/plugins/aws/util/get-credentials-kube.sh" || (
    echo "WARNING: Kubernetes authentication failed. This is OK if the Kubernetes"
    echo "cluster does not exist yet."
  )
fi

# TODO authenticate also to ECR
# echo
# echo "Getting credentials for Elastic Container Registry"
# "${taito_plugin_path}/util/get-credentials-ecr.sh"
