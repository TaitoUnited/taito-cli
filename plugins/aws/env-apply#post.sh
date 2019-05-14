#!/bin/bash
: "${taito_util_path:?}"

name=${1}

if [[ "${kubernetes_name}" ]] && "${taito_util_path}/confirm-execution.sh" "aws" "${name}" \
  "Configure AWS credentials for CI/CD pipeline"
then
  echo "Your CI/CD requires AWS access keys with the following settings and"
  echo "policies enabled:"
  echo
  echo "- Access type: Programmatic access"
  if [[ ${taito_container_registry_provider:-} == "aws" ]]; then
    echo "- AmazonEC2ContainerRegistryPowerUser policy for reading and writing"
    echo "  container images."
  fi
  echo "- KubernetesFullAccess policy for deploying application to Kubernetes."
  echo "  You can create the policy according to these instructions if it does"
  echo "  not exist yet:"
  echo "  https://docs.aws.amazon.com/eks/latest/userguide/EKS_IAM_user_policies.html"
  echo
  echo "TODO: Define more limited custom policies for CI/CD."
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
  echo "them for each git repository separately. You should mask and encrypt the"
  echo "AWS_SECRET_ACCESS_KEY value if your CI/CD provides such an option."
  echo
  echo "Press enter when done."
  read -r
  echo
  echo "The CI/CD user needs to have deployment rights for the Kubernetes cluster."
  echo "You most likely can add the rights in your taito zone configuration files"
  echo "like this:"
  echo
  echo "- Edit 'terraform/variables.tf': add the CI/CD user to 'map_users'"
  echo "  and increase the 'map_users_count' by one."
  echo "- Run 'taito zone apply'."
  echo
  echo "TODO: Limited Kubernetes group for CI/CD (not system:masters)"
  echo
  echo "Press enter when done."
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
