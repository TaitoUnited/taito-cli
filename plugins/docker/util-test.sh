#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"

dir="${taito_target:?Target not given}"
suite_filter="${1}"
test_filter="${2}"

# TODO Using remote database connection during tests does not currently
# work because db proxy is either started on host (local development) or
# inside taito container (ci runs), and tests are run inside the test container
# and therefore has not access to the proxied connection.

echo "# Running tests for ${dir} in ${taito_env} environment"
echo

if [[ "${taito_mode:-}" == "ci" ]]; then
  echo "Docker images before test:"
  docker images
fi

# Determine command to be run on init phase
init_command="echo 'Not running init (ci_exec_test_init=false)'" && \
if [[ "${ci_exec_test_init:-}" == "true" ]]; then
  init_command="taito init:${taito_env} --clean"
fi && \

# Determine test suite parameters
# Pass all environment variables with the "test_${dir}_" prefix for the test.
# Creates docker parameters: -e ENV_VAR='value' -e ENV_VAR2='value2' ...
docker_env_vars=$(env | grep "test_${dir}_" | sed "s/^test_${dir}_/-e /" \
  | sed "s/=/='/" | sed "s/$/'/" | tr '\n' ' ' | sed 's/.$//') && \
export_env_vars=$(env | grep "test_${dir}_" | sed "s/^test_${dir}_/export /" \
  | tr '\n' ' && ' | sed 's/.$//') && \

if [[ ${export_env_vars} ]]; then
  export_env_vars="${export_env_vars} && "
fi

docker_env_vars="-e taito_running_tests='true' ${docker_env_vars}"
export_env_vars="export taito_running_tests=true && ${export_env_vars}"

# Determine pod
# shellcheck disable=SC1090
. "${taito_cli_path}/plugins/docker-compose/util/determine-pod.sh" "${dir}" && \

# Determine command to be run on test phase
docker_compose="false"
compose_pre_cmd=""
compose_cmd="docker exec ${docker_env_vars} -it ${pod} ./test.sh SUITE ${test_filter}" && \
if [[ "${taito_env}" != "local" ]]; then
  # Running against a remote service
  container_test="${taito_project}-${dir}-test"
  image_test="${container_test}:latest"
  image_src="${container_test}er:latest"
  if [[ "${taito_mode:-}" != "ci" ]]; then
    # Use development image for testing
    # NOTE: does not exist if project dir is not named after taito_repo_name
    # NOTE: was ${taito_repo_name/-/}
    image_src="${taito_repo_name}_${taito_project}-${dir}"
  fi
  compose_pre_cmd="(docker image tag ${image_src} ${image_test} || \
    (echo ERROR: Container ${image_src} must be built before tests can be run. HINT: taito start && (exit 1))) && "
  if [[ -f ./docker-compose-test.yaml ]] && \
     [[ $(grep "${container_test}" "./docker-compose-test.yaml") ]]; then
    docker_compose="true"
    compose_cmd="docker-compose -f ./docker-compose-test.yaml run --rm ${docker_env_vars} ${container_test} sh -c 'sleep 5 && ./test.sh SUITE ${test_filter}'"
  else
    compose_cmd="docker run ${docker_env_vars} --network=host -v \"\$(pwd)/${dir}:/${dir}\" --entrypoint sh ${image_test} ./test.sh SUITE ${test_filter}"
  fi

  # NOTE: Quick hack for gcloud builder -> run tests directly inside taito-cli because
  # sql proxy fails to connect in docker-compose
  if [[ "${taito_plugins}" == *"gcloud-builder"* ]] && [[ "${taito_mode:-}" == "ci" ]]; then
    compose_cmd="${export_env_vars} cd ./${dir} && npm install && ./test.sh SUITE ${test_filter}"
  fi
fi && \

# Create test suite template from init and test phase commands
template="echo 'SUITE START' && ${init_command} && ${compose_cmd} && echo 'SUITE END'" && \

# Generate commands to be run by traversing all test suites
commands="" && \
echo "Reading test suites from ./${dir}/test-suites" && \
suites=( $(grep "${suite_filter}" "./${dir}/test-suites" 2> /dev/null) ) && \
for suite in "${suites[@]}"
do
  commands="${commands} && ${template//SUITE/$suite}"
done && \

# Execute tests
if [[ ! -z ${commands} ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "${compose_pre_cmd}${commands# && }"
fi && \

# Stop all test containers started by docker-compose
if [[ ${docker_compose} == "true" ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker-compose -f ./docker-compose-test.yaml down || echo OK"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
