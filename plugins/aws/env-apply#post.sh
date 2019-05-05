#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if "${taito_util_path}/confirm-execution.sh" "aws" "${name}" \
  "Configure AWS credentials for CI/CD pipeline"
then
  echo "Your CI/CD requires AWS access keys with the following settings enabled:"
  echo
  echo "- Access type: Programmatic access"
  echo "- AmazonEC2ContainerRegistryPowerUser policy for reading and writing"
  echo "  container images."
  echo
  echo "If you have already configured AWS credentials for your CI/CD, you can ignore"
  echo "this step."
  echo
  echo "Press enter to open the AWS IAM console for retrieving the access keys"
  read -r
  "${taito_util_path}/browser.sh" "https://console.aws.amazon.com/iam/home?#home"
  echo
  echo "Now add AWS credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) to your"
  echo "CI/CD pipeline according to your CI/CD provider instructions. If you"
  echo "configure them on organization/account level, you don't have to configure"
  echo "them for each git repository separately."
  echo
  echo "Press enter when done."
  read -r
  echo
  echo "The user also needs to have deployment rights for the Kubernetes cluster."
  echo "You most likely can add the rights in your taito zone config like this:"
  echo
  echo "- Edit 'terraform/variables.tf': add user to 'map_users' and increase"
  echo "  the 'map_users_count'."
  echo "- Run 'taito zone apply'."
  echo
  echo "Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
