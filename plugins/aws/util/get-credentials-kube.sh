#!/bin/bash
: "${kubernetes_name:?}"
: "${taito_provider_region:?}"

. "${taito_cli_path}/plugins/aws/util/aws-options.sh"

${taito_setv:?}
aws $aws_options eks \
  --region "${taito_provider_region}" update-kubeconfig \
  --name "${kubernetes_name}" \
  --alias "${kubernetes_name}" > ${taito_vout:-}
