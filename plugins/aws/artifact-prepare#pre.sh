#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

# echo
# echo "Authenticating to AWS"
# "${taito_plugin_path}/util/auth.sh" "${@}" && \
#
# if [[ "${taito_plugins:-} " == *"docker"* ]]; then
#   echo
#   echo "Getting credentials for Elastic Container Registry"
#   "${taito_plugin_path}/util/get-credentials-ecr.sh"
# fi && \
#
# if [[ "${taito_plugins:-} " == *"kubectl"* ]]; then
#   echo
#   echo "Getting credentials for kubernetes"
#   "${taito_plugin_path}/util/get-credentials-kube.sh"
# fi && \
#
# "${taito_util_path}/docker-commit.sh"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
