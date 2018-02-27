#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"

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
  init_command="taito init:${taito_env} --clean"
fi && \

# Determine command to be run on test phase
compose_pre_cmd=""
compose_cmd="docker exec -it ${pod} SUITE ${args}" && \
if [[ "${taito_env}" != "local" ]]; then
  # Running against a remote service
  image_test="${taito_project}-${dir}-test:latest"
  if [[ "${taito_mode:-}" == "ci" ]]; then
    # Use cached build stage of production build for testing
    compose_pre_cmd="docker build -f ./${dir}/Dockerfile.build --target builder -t ${image_test} ./${dir} && "
  else
    # Use pre-existing development image for testing
    image_dev="${taito_repo_name/-/}_${taito_project}-${dir}"
    compose_pre_cmd="(docker image tag ${image_dev} ${image_test} || \
      (echo ERROR: DEVELOPMENT CONTAINER ${image_dev} MUST BE BUILT FIRST && (exit 1))) && "
  fi
  compose_cmd="docker run -it --entrypoint sh ${image_test} SUITE ${args}"
fi && \

# Create test suite template from init and test phase commands
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
