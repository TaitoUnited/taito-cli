#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_plugin_path:?}"

if [[ "${taito_host_uname:-}" == "Darwin" ]]; then
  echo "macOS not supported"
  echo
  exit 1
fi

bucket="${taito_target:-$taito_storages}"
mount_path="./mounts/${bucket}"
mkdir -p "${mount_path}"

# Start rsync for mac hosts (not working)
# if [[ "${taito_host_uname:-}" == "Darwin" ]]; then
#   sync_path="${mount_path}"
#   mount_path="${mount_path}-mount"
#   mkdir -p "${mount_path}"
#   (
#     ${taito_setv:?}
#     sleep 4
#     echo "Syncing '${sync_path}' '${mount_path}'"
#     rsync -av --delete "${sync_path}" "${mount_path}"
#   ) &
# fi

echo "Mounting bucket '${bucket}'"
echo
echo "-----------------------------"
echo "NOTE: Press CTRL-C to unmount"
echo "-----------------------------"
echo

(
  ${taito_setv:?}
  # TODO remove 777 permission flags once files are no longer owned by root
  gcsfuse --dir-mode 777 --file-mode 777 "${@}" "${bucket}" "${mount_path}"
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"