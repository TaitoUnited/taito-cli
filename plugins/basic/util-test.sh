#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"

dir="${1}"
suite_filter="${2}"

echo "# Running tests for ${dir} in ${taito_env} environment"
echo

if [[ "${taito_mode:-}" == "ci" ]]; then
  echo "Docker images before test:"
  docker images
fi

# shellcheck disable=SC1090
. "${taito_cli_path}/plugins/docker/util/determine-pod.sh" "${dir}" && \

# Determine command to be run on init phase
init_command="echo 'Not running init (ci_exec_test_init=false)'" && \
if [[ "${ci_exec_test_init:-}" == "true" ]]; then
  init_command="taito init:${taito_env} --clean"
fi && \

# Pass all environment variables for the test run
test_env_vars=$(env | cut -f1 -d= | sed 's/^/-e /' | tr '\n' ' ')

# Determine command to be run on test phase
compose_pre_cmd=""
compose_cmd="docker exec ${test_env_vars} -it ${pod} SUITE" && \
if [[ "${taito_env}" != "local" ]]; then
  # Running against a remote service
  image_test="${taito_project}-${dir}-util-test:latest"
  image_src="${taito_project}-${dir}-tester:latest"
  if [[ "${taito_mode:-}" != "ci" ]]; then
    # Use development image for testing
    # NOTE: does not exist if project dir is not named after taito_repo_name
    image_src="${taito_repo_name/-/}_${taito_project}-${dir}"
  fi
  compose_pre_cmd="(docker image tag ${image_src} ${image_test} || \
    (echo ERROR: Container ${image_src} must be built before tests can be run && (exit 1))) && "
  compose_cmd="docker run ${test_env_vars} --entrypoint sh ${image_test} SUITE"
fi && \

# Create test suite template from init and test phase commands
template="echo 'SUITE START' && ${init_command} && ${compose_cmd} && echo 'SUITE END'" && \

# Generate commands to be run by traversing all test suites
commands="" && \
suites=($(find ./${dir}/test -name '*.sh' 2> /dev/null | grep "suite" | grep "${suite_filter}")) && \
for suite in "${suites[@]}"
do
  s=${suite/.\/${dir}/.}
  commands="${commands} && ${template//SUITE/$s}"
done

# Execute tests
if [[ ! -z ${commands} ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "${compose_pre_cmd}${commands# && }"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
