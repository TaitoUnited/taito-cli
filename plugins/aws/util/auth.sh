#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

options=" ${*} "

profile=${taito_provider_user_profile:-default}

if ! aws configure --profile "$profile" list &> /dev/null || \
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
  aws configure --profile "$profile"
  # TODO: docker-commit is called twice on 'taito auth'
  "${taito_util_path}/docker-commit.sh"
else
  echo "Already authenticated with profile '$profile'."
  echo "You can reauthenticate with 'taito auth --reset'."
fi

if [[ -n "${kubectl_name:-}" ]]; then
  "${taito_cli_path}/plugins/aws/util/get-credentials-kube.sh" || (
    echo "WARN: Kubernetes authentication failed. This is OK if the Kubernetes cluster"
    echo "does not exist yet."
  )
fi
