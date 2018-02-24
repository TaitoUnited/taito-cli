#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"

dir="${1}"
args="${*:2}"
suite_filter="${@: -1}"

if [[ "${suite_filter}" != "suite-"* ]]; then
  suite_filter=""
fi

# shellcheck disable=SC1090
. "${taito_cli_path}/plugins/docker/util/determine-pod.sh" "${dir}" && \

# Determine command to be run on init phase
init_command="echo 'Not running init (ci_exec_test_init=false)'" && \
if [[ "${ci_exec_test_init:-}" == "true" ]]; then
  init_command="taito init --clean"
fi && \

# Determine command to be run on test phase
compose_pre_cmd=""
compose_cmd="docker exec -it ${pod} SUITE ${args}" && \
if [[ "${taito_env}" != "local" ]]; then
  # Running against a remote service -> use Dockerfile.test
  compose_pre_cmd="docker build -t ${taito_project}-${dir}-test ./${dir} && "
  compose_cmd="docker run -it --entrypoint sh ${taito_project}-${dir}-test SUITE ${args}"
fi && \

# Create template from init and test phase commands
template="${init_command} && ${compose_cmd}" && \

# Generate commands to be run by traversing all test suites
commands="" && \
suites=($(ls ./${dir}/test/suite-*.sh 2> /dev/null | grep "${suite_filter}")) && \
for suite in "${suites[@]}"
do
  s=${suite/.\/${dir}/.}
  commands="${commands} && ${template/SUITE/$s}"
done

# Execute tests
if [[ ! -z ${commands} ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "${compose_pre_cmd}${commands# && }"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
