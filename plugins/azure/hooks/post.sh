#!/bin/bash
: "${taito_util_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  echo
  echo -e "${H1s}azure${H1e}"
  echo "Stopping all db proxies"
  echo "TODO implement"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
