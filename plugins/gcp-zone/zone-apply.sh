#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_zone:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_util_path}/confirm-execution.sh" "gcp-auth" "${name}" \
    "Authenticate to Kubernetes ${kubernetes_name:-}"
  then
      "${taito_cli_path}/plugins/gcp/util/get-credentials-kube.sh" && \
      "${taito_util_path}/docker-commit.sh"
  fi && \

  if "${taito_util_path}/confirm-execution.sh" "gcp-build-notifications" "${name}" \
    "Configure gcp build notifications"
  then
    "${taito_plugin_path}/util/setup-build-slack-notifications.sh"
  fi

fi && \

if [[ ${taito_uptime_provider:-} == "gcp" ]] && [[ ! ${taito_uptime_channels:-} ]] ; then
  if "${taito_util_path}/confirm-execution.sh" "gcp-uptime" "${name}" \
    "Configure monitoring channels for Google StackDriver"
  then
    echo "Add the following ${taito_messaging_app:-} channels with StackDriver web gui:"
    echo
    echo "- ${taito_messaging_builds_channel:-}"
    echo "- ${taito_messaging_critical_channel:-}"
    echo "- ${taito_messaging_monitoring_channel:-}"
    echo
    echo "Press enter to open StackDriver workspace settings in browser"
    read -r
    "${taito_util_path}/browser.sh" "https://app.google.stackdriver.com/settings/accounts/notifications/slack?project=${taito_zone}"
    echo "Press enter once done"
    echo
    gcloud -q --project "${taito_zone}" alpha monitoring channels list
    echo
    echo "Channels are shown above. Configure taito_uptime_channels setting in"
    echo "taito-config.sh using the ${taito_messaging_monitoring_channel} channel name"
    echo "For example:"
    echo
    echo "taito_uptime_channels=\"projects/${taito_zone}/notificationChannels/1234567890\""
    echo
    echo "Press enter once done"
    read -r
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
