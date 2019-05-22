#!/bin/bash
: "${taito_util_path:?}"

if [[ -n "${taito_admin_key}" ]]; then
  echo "# Encrypting admin credentials" && \
  (cd ~ && tar -zcvf admin_creds.tar.gz .config .kube) && \
  openssl aes-256-cbc -salt -in ~/admin_creds.tar.gz -out ~/admin_creds.enc \
    -pass env:taito_admin_key && \
  rm -rf ~/admin_creds.tar.gz ~/.config ~/.kube && \

  echo "# Restoring normal user credentials" && \
  mv ~/.config_normal ~/.config && \
  mv ~/.kube_normal ~/.kube
fi && \

echo "# Asking host to commit credentials to taito-cli container image" && \
export taito_admin_key="" && \
"${taito_util_path}/docker-commit.sh" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
