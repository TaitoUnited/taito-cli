#!/bin/bash
: "${taito_util_path:?}"

switches=" ${*} "

pipenv_command="pipenv install --dev"
if [[ "${switches}" == *"--clean"* ]]; then
  pipenv_command="pipenv update --clear --dev"
fi && \

"${taito_util_path}/execute-on-host-fg.sh" "\
pipenv --python 3.6 && \
${pipenv_command}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
