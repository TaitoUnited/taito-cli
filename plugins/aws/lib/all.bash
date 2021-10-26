#!/bin/bash

function aws::expose_aws_options () {
  if [[ $AWS_ACCESS_KEY_ID ]]; then
    profile="env var key"
    aws_options=""
  elif [[ ${taito_mode:-} == "ci" ]] && [[ ${taito_ci_provider:-} == "aws" ]]; then
    profile="default"
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

  if ! aws configure ${aws_options} list &> /dev/null || \
     [[ ${options} == *" --reset "* ]]; then
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
    taito::open_browser "https://console.aws.amazon.com/iam/home?#users"
    echo
    aws configure ${aws_options}
    # TODO: docker-commit is called twice on 'taito auth'
    taito::commit_changes
  else
    echo "Already authenticated with profile '$profile'."
    echo "You can reauthenticate with 'taito auth --reset'."
  fi

  # Set sane AWS defaults: https://github.com/aws/aws-cli/issues/2507
  aws configure set cli_follow_urlparam false

  if [[ ${kubernetes_name:-} ]]; then
    aws::authenticate_on_kubernetes || (
      echo
      echo "--------------------------------------------------------------------"
      echo "WARNING: Kubernetes authentication failed. Note that Kubernetes"
      echo "authentication failure is OK if the Kubernetes cluster does"
      echo "not exist yet."
      echo "--------------------------------------------------------------------"
    )
  fi

  # TODO authenticate also on ECR?
}

function aws::authenticate_on_ecr () {
  aws::expose_aws_options

  # NOTE: one-liner login to avoid passing password via CLI:
  # https://github.com/aws/aws-cli/issues/2875#issuecomment-487244855
  taito::executing_start
  aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $6}' | docker login -u AWS --password-stdin $(aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $7}')
}

function aws::authenticate_on_kubernetes () {
  aws::expose_aws_options

  taito::executing_start
  aws $aws_options eks \
    --region "${taito_provider_region}" update-kubeconfig \
    --name "${kubernetes_name}" \
    --alias "${kubernetes_name}" > "${taito_vout:-}" || (
    echo
    echo "TIP: If you got 'NoneType object is not iterable' error, try deleting ~/.kube/config"
    echo "from Taito CLI container:"
    echo
    echo "taito shell"
    echo "> rm ~/.kube/config"
    echo "> taito util commit"
    echo "> exit"
    echo
    echo "More info: https://github.com/aws/aws-cli/issues/4843"
    exit 1
  )
}

function aws::publish_current_target_assets () {
  if [[ -f ./taitoflag_images_exist ]] || ( \
     [[ ${taito_mode:-} == "ci" ]] && [[ ${ci_exec_build:-} == "false" ]] \
    ); then
    return
  fi

  # TODO: make assets and project buckets + path prefix configurable
  image_tag="${1}"
  if taito::is_current_target_of_type "function"; then
    # Publish function zip package to projects bucket
    source="./tmp/${taito_target:?}.zip"
    dest="s3://${taito_functions_bucket:?}/${taito_functions_path:?}/${image_tag}/${taito_target}.zip"
    options=""
  elif taito::is_current_target_of_type "static_content" && (
         ! taito::is_current_target_of_type "container" || (
           [[ ${taito_cdn_project_path:-} ]] &&
           [[ ${taito_cdn_project_path} != "-" ]]
         )
  ); then
    # Create separate stage.html for AWS Api Gateway stage (use /stage/* as base href)
    if [[ -f ./tmp/${taito_target}/service/index.html ]] &&
       [[ ! -f ./tmp/${taito_target}/service/stage.html ]]; then
      sed 's|<base href="/|<base href="/stage/|' \
        ./tmp/${taito_target}/service/index.html > ./tmp/${taito_target}/service/stage.html
    fi
    # Publish static assets to assets bucket
    source="./tmp/${taito_target}/service"
    dest="s3://${taito_static_assets_bucket:?}/${taito_static_assets_path:?}/${image_tag}/${taito_target}"
    options="--recursive"
  else
    echo "No need for copying assets to storage bucket"
  fi

  if [[ ${source} ]]; then
    echo "Copying ${taito_target} assets to ${dest}"
    aws::expose_aws_options
    taito::executing_start
    aws $aws_options s3 cp "${source}" "${dest}" ${options}
  fi
}

function aws::restart_all_functions () {
  echo "TODO: 'restart all functions' not implemented."
  echo "TIP: Change function environment variables to force restart."
  echo
}
