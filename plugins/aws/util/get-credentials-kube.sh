#!/bin/bash
: "${kubernetes_cluster:?}"
: "${kubernetes_user:?}"
: "${aws_region:?}"

profile=${aws_user_profile:-default}

${taito_setv:?}
aws --profile "${profile}" eks --region "${aws_region}" update-kubeconfig \
  --name "${kubernetes_cluster}" \
  --alias "${kubernetes_user}" &> ${taito_vout:-}
