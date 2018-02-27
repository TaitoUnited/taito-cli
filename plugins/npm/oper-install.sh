#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "

if [[ "${switches}" == *" --clean "* ]]; then
  "${taito_plugin_path}/util/clean.sh"
  # echo "Cleaning npm cache" && \
  # (${taito_setv:?}; su taito -s /bin/sh -c 'npm cache clean')
fi && \
echo "# Running 'npm install'..." && \
# NOTE: possible postinstalls will fail because running npm install as root
# inside taito container and npm will try to downgrade permissions before
# running postinstall script. However we cannot run install as taito user
# because then CI/CD will fail because of file permissions.
# NOTE: postinstall will run ok as root if --unsafe-perm switch is set
# but it must be passed on if postinstall calls npm install
(${taito_setv:?}; npm install --unsafe-perm) && \

if [[ "${switches}" == *" --all "* ]]; then
  echo
  echo "# Running 'npm run install-all'"
  # postinstalls will fail if run as root
  (${taito_setv:?}; su taito -s /bin/sh -c 'npm run install-all')
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
