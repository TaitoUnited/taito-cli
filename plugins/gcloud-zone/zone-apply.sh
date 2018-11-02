#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

opts=""
if [[ ${google_authuser:-} ]]; then
  opts="authuser=${google_authuser}&"
fi

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-auth" "${name}" \
    "Authenticate to Kubernetes ${kubectl_name:-}"
  then
      "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh" && \
      "${taito_cli_path}/util/docker-commit.sh"
  fi
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-external-ip" "${name}" \
  "Reserve an external IP address"
then
  echo "Reserve a static ip address. Leave it unattached. Press enter to open Google Cloud networking."
  read -r
  "${taito_util_path}/browser.sh" "https://console.cloud.google.com/networking/addresses/list?${opts}project=${gcloud_project_id}"
  echo
  echo "Enter the IP:"
  export zone_ingress_ip
  read -r zone_ingress_ip
  echo
  echo "Add the IP address ${zone_ingress_ip} to taito-config.sh. Press enter when done."
  read -r
  echo
  echo "Now configure domain name for IP ${zone_ingress_ip}."
  echo "For example '*.mydevcomain.com'. Press enter when done."
  read -r
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-personnel-rights" "${name}" \
  "Configure personnel rights"
then
  echo "Add 'Project Owner' role for the devops personnel."
  echo
  echo "Press enter to open permission management"
  read -r
  "${taito_util_path}/browser.sh" "https://console.cloud.google.com/iam-admin/iam?${opts}project=${gcloud_project_id}"
  echo
  echo "Press enter when done"
  read -r

  echo "If this zone is used for development, add at least the following rights for all developers:"
  echo
  echo Cloud Build Editor
  echo Cloud SQL Client
  echo Kubernetes Engine Developer
  echo Error Reporting User
  echo Source Repository Administrator
  echo Project Viewer
  echo

  # TODO how about these?
  # Cloud Build Viewer
  # Error Reporting Viewer
  # Cloud Security Scanner Viewer
  # Firebase Test Lab Viewer
  # Compute Viewer
  # DNS Reader
  # Genomics Viewer
  # Logs Viewer
  # Monitoring Viewer
  # Pub/Sub Viewer
  # Storage Object Creator

  echo "Press enter when done"
  read -r
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-builder-rights" "${name}" \
  "Configure cloud builder rights"
then
  echo "Add the following roles for service account XXX@cloudbuild.gserviceaccount.com"
  echo "so that the container builder is allowed to execute Kubernetes"
  echo "deployments and database migrations."
  echo
  echo "- Cloud Build Service Account"
  echo "- Cloud SQL Client"
  echo "- Kubernetes Engine Developer"
  echo
  echo "Press enter to open permission management"
  read -r
  "${taito_util_path}/browser.sh" "https://console.cloud.google.com/iam-admin/iam?${opts}project=${gcloud_project_id}"
  echo
  echo "Press enter when done"
  read -r
  echo
  echo "TODO create taito-public project that provides read access to taito-images for allAuthenticatedUsers"
  echo
  echo "Pulling a taito-cli container image from Docker Hub is slow. If you want"
  echo "to optimize your builds or you want to use a customized taito-cli image,"
  echo "you can save taito-cli container image to your own container image"
  echo "registry. If the image is not public, however, you need to give the"
  echo "service account XXX@cloudbuild.gserviceaccount.com a Storage Object Viewer"
  echo "role for the image repository bucket that contains the taito-cli image."
  echo
  echo "Press enter when done"
  read -r
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
  "Configure gcloud build notifications"
then
  "${taito_plugin_path}/util/setup-build-slack-notifications.sh"
fi && \

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-error-log-alerts" "${name}" \
  "Configure gcloud error log alerts"
then
  echo "TODO configure error log notifications"
  echo
  echo "Press enter when done"
  read -r
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
