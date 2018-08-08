#!/bin/bash
: "${taito_util_path:?}"
: "${taito_project_path:?}"
: "${taito_setv:?}"

echo "Secrets in docker-compose.yaml:"
(${taito_setv}; cat docker-compose.yaml | grep -i "SECRET\|PASSWORD\|KEY\|ID")
echo

if [[ -f ./taito-run-env.sh ]]; then
  echo "Secrets in taito-run-env.sh:"
  (${taito_setv}; cat ./taito-run-env.sh)
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
