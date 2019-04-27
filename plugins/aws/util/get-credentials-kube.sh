#!/bin/bash
: "${kubernetes_name:?}"
: "${aws_region:?}"

profile=${aws_user_profile:-default}

${taito_setv:?}
aws --profile "${profile}" eks --region "${aws_region}" update-kubeconfig \
  --name "${kubernetes_name}" \
  --alias "${kubernetes_name}" &> ${taito_vout:-}
