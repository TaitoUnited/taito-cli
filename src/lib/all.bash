#!/bin/bash -e
: "${taito_lib_path:?}"

# shellcheck source=config.bash
. "${taito_lib_path}/config.bash"
# shellcheck source=docker.bash
. "${taito_lib_path}/docker.bash"
# shellcheck source=exec.bash
. "${taito_lib_path}/exec.bash"
# shellcheck source=misc.bash
. "${taito_lib_path}/misc.bash"
# shellcheck source=open.bash
. "${taito_lib_path}/open.bash"
# shellcheck source=secret.bash
. "${taito_lib_path}/secret.bash"
# shellcheck source=target.bash
. "${taito_lib_path}/target.bash"
# shellcheck source=terminal.bash
. "${taito_lib_path}/terminal.bash"
