#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-auth" "${name}" \
    "Authenticate to Kubernetes ${kubectl_name:-}"
  then
      "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh" && \
      "${taito_cli_path}/util/docker-commit.sh"
  fi && \

  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-external-ip" "${name}" \
    "Reserve an external IP address for ${kubectl_name}"
  then
    # TODO https://cloud.google.com/kubernetes-engine/docs/how-to/cloud-armor-backendconfig
    gcloud compute addresses create "${kubectl_name}" --global

    # echo "Reserve a static ip address. Leave it unattached. Press enter to open Google Cloud networking."
    # read -r
    # "${taito_util_path}/browser.sh" "https://console.cloud.google.com/networking/addresses/list?${opts}project=${gcloud_project_id}"
    # echo

    gcloud compute addresses list --filter "name=${kubectl_name}"

    echo "Enter the IP:"
    export taito_zone_default_ip
    read -r taito_zone_default_ip
    echo
    echo "Add the IP address ${taito_zone_default_ip} to taito-config.sh. Press enter when done."
    read -r
    echo
    echo "Now configure domain name for IP ${taito_zone_default_ip}."
    echo "For example '*.mydevcomain.com'. Press enter when done."
    read -r
  fi && \

  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
    "Configure gcloud build notifications"
  then
    "${taito_plugin_path}/util/setup-build-slack-notifications.sh"
  fi

fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
