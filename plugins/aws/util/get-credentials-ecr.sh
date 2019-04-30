#!/bin/bash
: "${kubernetes_name:?}"
: "${taito_provider_region:?}"

. "${taito_cli_path}/plugins/aws/util/aws-options.sh"

# TODO: displays 'WARNING! Using --password via the CLI is insecure. Use --password-stdin.'
# see -> https://github.com/aws/aws-cli/issues/2875

${taito_setv:?}
docker_login_command=$(aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}")

eval $docker_login_command
