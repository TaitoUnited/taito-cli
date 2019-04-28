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
  echo "- TODO policy for deploying applications to Kubernetes and accessing"
  echo "  database using Kubernetes as a proxy."
  echo
  echo "If you have already configured AWS credentials for your CI/CD, you can ignore"
  echo "this step."
  echo
  echo "Press enter to open the AWS IAM console for retrieving the access keys"
  read -r
  "${taito_util_path}/browser.sh" "https://console.aws.amazon.com/iam/home?#home"
  echo
  echo "Now add AWS credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) to your"
  echo "CI/CD pipeline according to your CI/CD provider instructions."
  echo "Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
