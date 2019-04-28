#!/bin/bash
: "${kubernetes_name:?}"
: "${taito_provider_region:?}"

profile=${taito_provider_user_profile:-default}

${taito_setv:?}
aws --profile "${profile}" eks \
  --region "${taito_provider_region}" update-kubeconfig \
  --name "${kubernetes_name}" \
  --alias "${kubernetes_name}" &> ${taito_vout:-}
