#!/bin/bash

create_temp_dir="${2}"
taito_plugin_path="${3:-$BATS_TEST_DIRNAME}"

setup() {
  # Setup temporary project directory
  TEST_TMPDIR="${taito_plugin_path}/tmp"
  if [[ "${create_temp_dir}" == "true" ]]; then
    mkdir -p "${TEST_TMPDIR}/node_modules"
    mkdir -p "${TEST_TMPDIR}/client/node_modules"
    cd "${TEST_TMPDIR}"
  fi

  # Override some executables with mocks
  export PATH="${taito_plugin_path}/mocks:${PATH}"
  export taito_util_path="${taito_plugin_path}/../../unit/mocks"

  # Set some variables
  export taito_env="local"
  export taito_vout="/dev/stdout"
  export taito_skip_override="false"
  export taito_testing="true"
}

teardown() {
  # Delete temporary directory if it exists
  if [[ -d "${TEST_TMPDIR}" ]]; then rm -rf "${TEST_TMPDIR}"; fi
}
